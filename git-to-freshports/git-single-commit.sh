#!/bin/sh

# process a single commit
# based upon https://github.com/FreshPorts/git_proc_commit/issues/3
# An idea from https://github.com/sarcasticadmin

# a single commit hash
commit_hash=$1

if [ ! -f /usr/local/etc/freshports/config.sh ]
then
	echo "/usr/local/etc/freshports/config.sh not found by $0"
	exit 1
fi

. /usr/local/etc/freshports/config.sh

LOGGERTAG='git-single-commit.sh'

# where is the repo directory?
# We may have to pass the repo name in as a parameter.
REPODIR="${INGRESS_PORTS_DIR_BASE}/freebsd-ports"


logfile(){
  msg=$1
  
  timestamp=`date "+%Y.%m.%d %H:%M:%S"` 
  echo ${timestamp} ${LOGGERTAG} $msg
}

${LOGGER} -t ${LOGGERTAG} has started
logfile "started"

# where we do dump the XML files which we create?
XML="${INGRESS_MSGDIR}/incoming"

logfile "repo is $REPODIR"
logfile "XML dir is $XML"

cd ${REPODIR}

logfile "${SCRIPTDIR}/git-to-freshports-xml.py --path ${REPODIR} --single-commit ${commit_hash} --spooling ${INGRESS_SPOOLINGDIR} --output ${XML}"
         ${SCRIPTDIR}/git-to-freshports-xml.py --path ${REPODIR} --single-commit ${commit_hash} --spooling ${INGRESS_SPOOLINGDIR} --output ${XML}

${LOGGER} -t ${LOGGERTAG} ending
logfile "ending"
