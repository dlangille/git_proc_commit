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

LOGGERTAG='git-delta.sh'

logfile(){
  msg=$1
  
  timestamp=`date "+%Y.%m.%d %H:%M:%S"` 
  echo ${timestamp} ${LOGGERTAG} $msg
}

${LOGGER} -t ${LOGGERTAG} has started
logfile "has started"

# what remote are we using on this repo?
REMOTE='origin'

# where is the repo directory?
REPODIR="${FRESHPORTS_JAIL_BASE_DIR}${PORTSDIRBASE}PORTS-head-git"

# where we do dump the XML files which we create?
XML="${MSGDIR}/incoming"

logfile "repo is $REPODIR"
logfile "XML dir is $XML"

cd ${REPODIR}

# Update local copies of remote branches
logfile "running: ${GIT} fetch $REMOTE"
${GIT} fetch $REMOTE

# Make sure branch is clean and on master
#logfile "running: ${GIT} reset --hard HEAD"
#${GIT} reset --hard HEAD


logfile "running: ${GIT} checkout master"
${GIT} checkout master



# Get the first commit for our starting point
STARTPOINT=$(${GIT} log master..$REMOTE/master --oneline --reverse | head -n 1 | cut -d' ' -f1)

if [ "${STARTPOINT}x" = 'x' ]
then
	logfile "STARTPOINT is empty; there must not be any new commits to process"
	${LOGGER} -t ${LOGGERTAG} ending - no commits found
	logfile "ending"
	exit 1
else
	logfile "STARTPOINT = ${STARTPOINT}"
fi


# Bring local branch up-to-date with the local remote
logfile "running; ${GIT} rebase $REMOTE/master"
${GIT} rebase $REMOTE/master


# get list of commits, if only to document them here
logfile "running: ${GIT} rev-list ${STARTPOINT}..HEAD"
commits=`${GIT} rev-list ${STARTPOINT}..HEAD`
echo $commits

logfile "${SCRIPTDIR}/git-to-freshports-xml.py --path ${FRESHPORTS_JAIL_BASE_DIR}${PORTSDIRBASE}PORTS-head-git --commit ${STARTPOINT} --output ${XML}"
         ${SCRIPTDIR}/git-to-freshports-xml.py --path ${FRESHPORTS_JAIL_BASE_DIR}${PORTSDIRBASE}PORTS-head-git --commit ${STARTPOINT} --output ${XML}

${LOGGER} -t ${LOGGERTAG} ending
logfile "ending"
