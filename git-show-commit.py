#!/usr/local/bin/python3

import git
repo = git.Repo("~/src/freebsd-ports")
commits = list(repo.iter_commits("master", max_count=9))
dir(commits[0])
print(commits[0].author)
print(commits[0].message)
print(commits[0].hexsha)
