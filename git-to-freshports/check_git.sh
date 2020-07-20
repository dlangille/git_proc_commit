#!/bin/sh

# This script exists mainly to redirect the output of git-delta.sh to a logfile.
#

if [ ! -f /usr/local/etc/freshports/config.sh ]
then
	echo "/usr/local/etc/freshports/config.sh not found by $0"
	exit 1
fi

. /usr/local/etc/freshports/config.sh

LOGGERTAG=check_git.sh

${LOGGER} -t ${LOGGERTAG} $0 has started

# redirect everything into the file
${SCRIPTDIR}/git-delta.sh >> ${GITLOG} 2>&1

/bin/rm ${CHECKGITFILE}

${LOGGER} -t ${LOGGERTAG} $0 has finished
