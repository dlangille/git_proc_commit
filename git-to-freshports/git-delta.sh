#!/bin/sh

# process the new commits
# based upon https://github.com/FreshPorts/git_proc_commit/issues/3
# An idea from https://github.com/sarcasticadmin

if [ ! -f /usr/local/etc/freshports/config.sh ]
then
	echo "/usr/local/etc/freshports/config.sh.sh not found by $0"
	exit 1
fi

. /usr/local/etc/freshports/config.sh

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
# We may have to pass the repo name in as a parameter.
REPODIR="${INGRESS_PORTS_DIR_BASE}/freebsd-ports"
LATEST_FILE="${INGRESS_PORTS_DIR_BASE}/latest.freebsd-ports"

# where we do dump the XML files which we create?
XML="${INGRESS_MSGDIR}/incoming"

logfile "repo is $REPODIR"
logfile "XML dir is $XML"

cd ${REPODIR}

# Update local copies of remote branches
logfile "running: ${GIT} fetch $REMOTE"
${GIT} fetch $REMOTE

logfile "running: ${GIT} checkout master"
${GIT} checkout master

# Get the first commit for our starting point
#STARTPOINT=$(${GIT} log --format=%h -n1 --reverse master..$REMOTE/master)

# let's try having the latest commt in this this.
STARTPOINT=`cat ${LATEST_FILE}`

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

logfile "${SCRIPTDIR}/git-to-freshports-xml.py --path ${REPODIR} --commit ${STARTPOINT} --spooling ${INGRESS_SPOOLINGDIR} --output ${XML}"
         ${SCRIPTDIR}/git-to-freshports-xml.py --path ${REPODIR} --commit ${STARTPOINT} --spooling ${INGRESS_SPOOLINGDIR} --output ${XML}
         
new_latest=`${GIT}  rev-parse HEAD`
echo $new_latest > ${LATEST_FILE}

${LOGGER} -t ${LOGGERTAG} ending
logfile "ending"
