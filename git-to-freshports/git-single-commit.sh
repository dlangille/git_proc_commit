#!/bin/sh

# process a single commit
# based upon https://github.com/FreshPorts/git_proc_commit/issues/3
# An idea from https://github.com/sarcasticadmin

# a single commit hash
$commit_hash=$1

if [ ! -f config.sh ]
then
	echo "config.sh not found by freebsd-git.sh..."
	exit 1
fi

. config.sh

LOGGERTAG='git-single-commit.sh'

logfile(){
  msg=$1
  
  timestamp=`date "+%Y.%m.%d %H:%M:%S"` 
  echo ${timestamp} ${LOGGERTAG} $msg
}

${LOGGER} -t ${LOGGERTAG} has started
logfile "started"

# where we do dump the XML files which we create?
XML="${MSGDIR}/incoming"

logfile "repo is $REPODIR"
logfile "XML dir is $XML"

cd ${REPODIR}

logfile "${SCRIPTDIR}/git-to-freshports-xml.py --path ${FRESHPORTS_JAIL_BASE_DIR}${PORTSDIRBASE}PORTS-head-git --single-commit --commit ${commit_hash} --output ${XML}"
         ${SCRIPTDIR}/git-to-freshports-xml.py --path ${FRESHPORTS_JAIL_BASE_DIR}${PORTSDIRBASE}PORTS-head-git --single-commit --commit ${commit_hash} --output ${XML}

${LOGGER} -t ${LOGGERTAG} ending
logfile "ending"
