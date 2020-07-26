#!/bin/sh

# process a single commit
# based upon https://github.com/FreshPorts/git_proc_commit/issues/3
# An idea from https://github.com/sarcasticadmin

# a single commit hash
repo=$1
commit_hash=$2

if [ ! -f /usr/local/etc/freshports/config.sh ]
then
	echo "/usr/local/etc/freshports/config.sh not found by $0"
	exit 1
fi

. /usr/local/etc/freshports/config.sh

LOGGERTAG='git-single-commit.sh'

# convert the repo label to a physical directory on disk
dir=`convert_repo_label_to_directory ${repo}`

# empty means error
if [  "${dir}" == "" ]; then
   ${LOGGER} -t ${LOGGERTAG} FATAL error, repo='${repo}' is unknown: cannot translate it to a directory name
   continue
fi


# where is the repo directory?
# We may have to pass the repo name in as a parameter.
REPODIR="${INGRESS_PORTS_DIR_BASE}/freebsd-ports"

if [ ! -d ${REPODIR} ]; then
   ${LOGGER} -t ${LOGGERTAG} FATAL error, REPODIR='${REPODIR}' is not a directory
   continue
fi
  

${LOGGER} -t ${LOGGERTAG} has started
logfile "started"

# where we do dump the XML files which we create?
XML="${INGRESS_MSGDIR}/incoming"

logfile "repo is $REPODIR"
logfile "XML dir is $XML"

cd ${REPODIR}

logfile "${SCRIPTDIR}/git-to-freshports-xml.py --repo ${repo} --path ${REPODIR} --single-commit ${commit_hash} --spooling ${INGRESS_SPOOLINGDIR} --output ${XML}"
         ${SCRIPTDIR}/git-to-freshports-xml.py --repo ${repo} --path ${REPODIR} --single-commit ${commit_hash} --spooling ${INGRESS_SPOOLINGDIR} --output ${XML}

${LOGGER} -t ${LOGGERTAG} ending
logfile "ending"
