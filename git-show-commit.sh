#!/bin/sh

# the latest commit we have processed
latest="3bd153c2494182bb89915e6fc9222288c154285f" # [NEW PORT]: devel/py-oci - Wed Sep 18 17:14:34 2019 +0000

# before running this script:
# mkdir ~/src
# cd ~/src
# git clone git@github.com:freebsd/freebsd-ports.git

repo_dir=~/src/freebsd-ports

GIT="/usr/local/bin/git"

cd "${repo_dir}"
commits=`${GIT} rev-list ${latest}..HEAD`
for commit in $commits
do
  echo $commit
done
