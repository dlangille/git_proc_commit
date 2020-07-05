import pytest
import git
import sys
from unittest.mock import patch, Mock
from tempfile import TemporaryDirectory
from pathlib import Path


MODULE_UNDER_TEST = __import__('git-to-freshports-xml')


@pytest.fixture(scope='module')
def git_repo() -> git.Repo:

    with TemporaryDirectory() as repo_dir:
        repo_dir = Path(repo_dir)
        repo = git.Repo.init(repo_dir, mkdir=False)

        for f in ('1.txt', '2.txt', '3.txt', '4.txt', '5.txt'):
            (repo_dir / f).open('wb').close()
            repo.index.add(f)
            repo.index.commit(f"Create {f}")

        yield repo
        repo.close()


@pytest.fixture(autouse=True)
def disable_logger(monkeypatch):
    monkeypatch.setattr(MODULE_UNDER_TEST, 'configure_logging', Mock())


def test_single_commit(git_repo: git.Repo, tmp_path: Path):
    commit = git_repo.commit('HEAD~')
    call_args = ['git-to-freshports-xml',
                 f'--path={git_repo.working_dir}',
                 f'--single-commit={commit.hexsha}',
                 f'--output={tmp_path}']

    with patch.object(sys, 'argv', call_args):
        MODULE_UNDER_TEST.main()

    result_files = list(tmp_path.iterdir())
    assert len(result_files) == 1, "Must be exactly one commit"

    commit_filename = result_files[0].name
    assert commit.hexsha in commit_filename


def test_commit_range(git_repo: git.Repo, tmp_path: Path):
    first_commit = git_repo.commit('HEAD~3')
    second_commit = git_repo.commit('HEAD~1')

    call_args = ['git-to-freshports-xml',
                 f'--path={git_repo.working_dir}',
                 f'--commit-range={first_commit.hexsha}..{second_commit.hexsha}',
                 f'--output={tmp_path}']

    with patch.object(sys, 'argv', call_args):
        MODULE_UNDER_TEST.main()

    result_files = list(tmp_path.iterdir())
    assert len(result_files) == 2, "Must be exactly two commits"

    commit_filenames = [x.name for x in result_files]
    assert git_repo.commit('HEAD~2').hexsha in commit_filenames[0]
    assert second_commit.hexsha in commit_filenames[1]


def test_commit_to_head(git_repo: git.Repo, tmp_path: Path):
    commit = git_repo.commit('HEAD~3')

    call_args = ['git-to-freshports-xml',
                 f'--path={git_repo.working_dir}',
                 f'--commit={commit.hexsha}',
                 f'--output={tmp_path}']

    with patch.object(sys, 'argv', call_args):
        MODULE_UNDER_TEST.main()

    result_files = list(tmp_path.iterdir())
    assert len(result_files) == 3, "Must be exactly three commits"
    assert git_repo.commit('HEAD~2').hexsha in result_files[0].name
