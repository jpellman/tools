#!/bin/bash

# Define the path to the Backup Volume.
BACKUPVOL=/Volumes/BACKUP1

# Use GNU's cp instead of the BSD version so that we can preserve hard links.
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Create the directory for today's backup.
CUR_BACK=${BACKUPVOL}/$(date +"%m%d%y")
LAST_BACK=${BACKUPVOL}/$(ls -t ${BACKUPVOL} | tail -1)

# Make a recursive hard link directory for the last backup.
cp -al ${LAST_BACK} ${CUR_BACK}

# Select directories in my home to back up.
BACKUP=(Documents Pictures)

for bakdir in ${BACKUP[@]};
do
   rsync -avu ${HOME}/${bakdir} ${CUR_BACK} --delete 
done
