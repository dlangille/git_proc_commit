import pytest
import pygit2
import sys
from unittest.mock import patch, Mock
from tempfile import TemporaryDirectory
from pathlib import Path


MODULE_UNDER_TEST = __import__('git-to-freshports-xml')


@pytest.fixture(scope='module')
def git_repo() -> pygit2.Repository:

    with TemporaryDirectory() as repo_dir:
        repo_dir = Path(repo_dir)
        repo = pygit2.init_repository(repo_dir, flags=0)

        author = pygit2.Signature('Alice Author', 'alice@authors.tld')
        committer = pygit2.Signature('Cecil Committer', 'cecil@committers.tld')
        parent = None

        for f in ('1.txt', '2.txt', '3.txt', '4.txt', '5.txt'):
            (repo_dir / f).open('wb').close()
            repo.index.add_all()
            repo.index.write()
            tree = repo.index.write_tree()
            parents = [parent] if parent else []
            parent = repo.create_commit(
                'refs/heads/master',
                author,
                committer,
                f"Create {f}",
                tree,
                parents
            )

        yield repo


@pytest.fixture(autouse=True)
def disable_logger(monkeypatch):
    monkeypatch.setattr(MODULE_UNDER_TEST, 'configure_logging', Mock())


def test_single_commit(git_repo: pygit2.Repository, tmp_path: Path):
    commit = git_repo.revparse_single('HEAD~')
    call_args = ['git-to-freshports-xml',
                 f'--path={git_repo.workdir}',
                 f'--single-commit={commit.hex}',
                 f'--output={tmp_path}',
                 f'--spool={tmp_path}',
                 '--repo=ports']

    with patch.object(sys, 'argv', call_args):
        MODULE_UNDER_TEST.main()

    result_files = list(tmp_path.iterdir())
    assert len(result_files) == 1, "Must be exactly one commit"

    commit_filename = result_files[0].name
    assert commit.hex in commit_filename


def test_commit_range(git_repo: pygit2.Repository, tmp_path: Path):
    first_commit = git_repo.revparse_single('HEAD~3')
    second_commit = git_repo.revparse_single('HEAD~1')

    call_args = ['git-to-freshports-xml',
                 f'--path={git_repo.workdir}',
                 f'--commit-range={first_commit.hex}..{second_commit.hex}',
                 f'--output={tmp_path}',
                 f'--spool={tmp_path}',
                 '--repo=ports']

    with patch.object(sys, 'argv', call_args):
        MODULE_UNDER_TEST.main()

    result_files = list(tmp_path.iterdir())
    assert len(result_files) == 2, "Must be exactly two commits"

    commit_filenames = [x.name for x in result_files]
    assert git_repo.revparse_single('HEAD~2').hex in commit_filenames[0]
    assert second_commit.hex in commit_filenames[1]


def test_commit_to_head(git_repo: pygit2.Repository, tmp_path: Path):
    commit = git_repo.revparse_single('HEAD~3')

    call_args = ['git-to-freshports-xml',
                 f'--path={git_repo.workdir}',
                 f'--commit={commit.hex}',
                 f'--output={tmp_path}',
                 f'--spool={tmp_path}',
                 '--repo=ports']

    with patch.object(sys, 'argv', call_args):
        MODULE_UNDER_TEST.main()

    result_files = list(tmp_path.iterdir())
    assert len(result_files) == 3, "Must be exactly three commits"
    assert git_repo.revparse_single('HEAD~2').hex in result_files[0].name
