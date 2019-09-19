#!/bin/sh

# the latest commit we have processed
latest="ee38cccad8f76b807206165324e7bf771aa981dc"

repo_dir="/Users/dan/src/acme.sh"

GIT="/usr/bin/git"

cd $repo_dir
commits=`${GIT} rev-list ${latest}..HEAD`
for commit in $commits
do
  echo $commit
done
