#!/bin/sh

# process the new commits
# based upon https://github.com/FreshPorts/git_proc_commit/issues/3
# An idea from https://github.com/sarcasticadmin

if [ ! -f /usr/local/etc/freshports/config.sh ]
then
	echo "/usr/local/etc/freshports/config.sh.sh not found by $0"
	exit 1
fi

# this can be a space separated list of repositories to check
# e.g. "doc ports src"
repos=$1

. /usr/local/etc/freshports/config.sh

LOGGERTAG='git-delta.sh'

logfile "has started. Will check these repos: '${repos}'"

# what remote are we using on this repo?
REMOTE='origin'

# where we do dump the XML files which we create?
XML="${INGRESS_MSGDIR}/incoming"

logfile "XML dir is $XML"

for repo in ${repos}
do
   logfile "Now processing repo: ${repo}"

   # convert the repo label to a physical directory on disk
   dir=`convert_repo_label_to_directory ${repo}`

   # empty means error
   if [  "${dir}" == "" ]; then
      logfile "FATAL error, repo='${repo}' is unknown: cannot translate it to a directory name"
      continue
   fi

   # where is the repo directory?
   # This is the directory which contains the repos.
   REPODIR="${INGRESS_PORTS_DIR_BASE}/${dir}"
   LATEST_FILE="${INGRESS_PORTS_DIR_BASE}/latest.${dir}"

   if [ -d ${REPODIR} ]; then
      logfile "REPODIR='${REPODIR}' exists"
   else
      logfile "FATAL error, REPODIR='${REPODIR}' is not a directory"
      continue
   fi

   if [ -f ${LATEST_FILE} ]; then
      logfile "LATEST_FILE='${LATEST_FILE}' exists"
   else
      logfile "FATAL error, LATEST_FILE='${LATEST_FILE}' does not exist. We need a starting point."
      continue
   fi

   logfile "Repodir is $REPODIR"
   # on with the work

   cd ${REPODIR}

   # Bring local branch up-to-date with the local remote
   logfile "Running: ${GIT} pull:"
   ${GIT} pull
   logfile "Done."

   # let's try having the latest commt in this this.
   STARTPOINT=`cat ${LATEST_FILE}`

   if [ "${STARTPOINT}x" = 'x' ]
   then
      logfile "STARTPOINT is empty; there must not be any new commits to process"
      logfile "Not proceeding with this repo: '${repo}'"
      continue
   else
      logfile "STARTPOINT = ${STARTPOINT}"
   fi

   # get list of commits, if only to document them here
   logfile "Running: ${GIT} rev-list ${STARTPOINT}..HEAD"
   commits=`${GIT} rev-list ${STARTPOINT}..HEAD`
   logfile "Done."

   if [ -z "commits" ]
   then
     logfile "No commits were found"
   else
     logfile "The commits found are:"
     for commit in $commits
     do
        logfile "$commit"
     done
   fi

   logfile "${SCRIPTDIR}/git-to-freshports-xml.py --repo ${repo} --path ${REPODIR} --commit ${STARTPOINT} --spooling ${INGRESS_SPOOLINGDIR} --output ${XML}"
            ${SCRIPTDIR}/git-to-freshports-xml.py --repo ${repo} --path ${REPODIR} --commit ${STARTPOINT} --spooling ${INGRESS_SPOOLINGDIR} --output ${XML}
         
   new_latest=`${GIT}  rev-parse HEAD`
   echo $new_latest > ${LATEST_FILE}

done

logfile "Ending"
