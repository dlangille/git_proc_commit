#!/bin/sh

# the latest commit we have processed
latest="240cab957e5c13c50ed539ed7bc7d511bb1c3368" # [NEW PORT]: devel/py-oci - Wed Sep 18 17:14:34 2019 +0000

# before running this script:
# mkdir ~/src
# cd ~/src
# git clone git@github.com:freebsd/freebsd-ports.git

repo_dir=~freshports/ports-jail/var/db/repos/freebsd-ports

GIT="/usr/local/bin/git"

cd "${repo_dir}"
commits=`${GIT} rev-list ${latest}..HEAD`
for commit in $commits
do
  echo $commit
done
