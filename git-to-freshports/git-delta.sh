#!/bin/sh

# process the new commits
# based upon https://github.com/FreshPorts/git_proc_commit/issues/3
# An idea from https://github.com/sarcasticadmin

if [ ! -f config.sh ]
then
	echo "config.sh not found by freebsd-git.sh..."
	exit 1
fi

. config.sh

${LOGGER} -t ${LOGGERTAG} $0 has started

LOGGERTAG='fp-daemon'

GIT="/usr/local/bin/git"

REMOTE='origin'

REPODIR="${FRESHPORTS_JAIL_BASE_DIR}${PORTSDIRBASE}PORTS-head-git"
echo ${REPODIR}

PROCESS_ID=${$}
XML="${MSGDIR}/recent"

cd ${REPODIR}

# Update local copies of remote branches
${GIT} fetch $REMOTE

# Make sure branch is clean and on master
${GIT} reset --hard HEAD
${GIT} checkout master

# Get the first commit for our starting point
STARTPOINT=$(${GIT} log master..$REMOTE/master --oneline --reverse | head -n 1 | cut -d' ' -f1)

# Bring local branch up-to-date with the local remote
${GIT} rebase $REMOTE/master

# Call xml conversion with starting point
#commits=`${GIT} rev-list ${STARTPOINT}..HEAD`
#echo We have these commits to process: ${commits}

echo starting point is ${STARTPOINT}
#die waiting for you do try this on the commandline: git rev-list  ${STARTPOINT}..HEAD
#for commit in $commits
#do
#  echo about to process $commit
#  FILE=`date +%Y.%m.%d.%H.%M.%S`.$PROCESS_ID.${commit}.txt

  ${LOGGER} -t ${LOGGERTAG} will invoke: ${SCRIPTDIR}/git-to-freshports-xml.py --path ${FRESHPORTS_JAIL_BASE_DIR}${PORTSDIRBASE}PORTS-head-git --commit ${STARTPOINT} --output ${XML}/${FILE}.xml
                                         ${SCRIPTDIR}/git-to-freshports-xml.py --path ${FRESHPORTS_JAIL_BASE_DIR}${PORTSDIRBASE}PORTS-head-git --commit ${STARTPOINT} --output ${XML}
#  exit
#  echo $commit
#done

#python3 git-to-freshports.py -c $STARTPOINT
echo "Would have ran git-to-freshport.py starting at: $STARTPOINT"
