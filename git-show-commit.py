#!/usr/local/bin/python3

import git
repo = git.Repo("~/src/freebsd-ports")
commits = list(repo.iter_commits("3bd153c2494182bb89915e6fc9222288c154285f..HEAD"))
for commit in commits[::-1]:
  print(commit.hexsha)


