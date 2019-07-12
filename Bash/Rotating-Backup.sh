#!/bin/bash
# Use this script to make backups of important folders.  It has 2 stages: 1st
# stage creates a local backup on the machine, then the 2nd stage mirrors those
# backups to a remote location

# 7-Zip and rsync are pre-reqs to archive and sync the files, you need to make sure 
# they're installed and accessible from the command shell before using.
# As always, make sure you test that it works before trusting it.

# Set variables
# It is best to avoid spaces whenever possible
APPLICATION_NAME="SampleApplication"
SERVER_FOLDER="/path/to/folders"
LOCAL_BACKUP_FOLDER="/backups/$APPLICATION_NAME"
LOCAL_TEMP_FOLDER="/tmp/$APPLICATION_NAME"
BACKUP_DESTINATION="//RemoteFileServer/Backups/$APPLICATION_NAME"
ROTATE_DAYS=5 # Number of days to keep backups

# Uses the date format YYYY-MM-DD (ex. 2019-07-23)
BACKUP_DATE=$(date +%F)

if ! [ -d $LOCAL_BACKUP_FOLDER ]; then 
  echo "Creating local backup folder"
  mkdir -p $LOCAL_BACKUP_FOLDER
fi

echo 'Rotate the folders, if they already exist'

# Delete the oldest backup as it is now older than the maximum days to keep
last_folder="$LOCAL_BACKUP_FOLDER/Day$ROTATE_DAYS"
if [ -d "$last_folder" ]; then 
  rm -Rf $last_folder
fi

for ((count=$((ROTATE_DAYS - 1));count>0;count-=1)); do
  current_folder="$LOCAL_BACKUP_FOLDER/Day$count"
  if [ -d $current_folder ]; then
    cp -r -p $current_folder "$LOCAL_BACKUP_FOLDER/Day$(( $count + 1 ))" # Copy and preserve timestamp
    rm -Rf $current_folder
  fi
done

mkdir -p "$LOCAL_BACKUP_FOLDER/Day1"

# It's important to copy the files first because if any of them are in use
# at the time 7-Zip tries to archive them, they will most likely be skipped.
echo 'Copying the files to a temporary location'
if [ -d "$LOCAL_TEMP_FOLDER" ]; then 
  rm -Rf $LOCAL_TEMP_FOLDER
fi

cp -r $SERVER_FOLDER $LOCAL_TEMP_FOLDER

# In addition to creating the archive, it also creates an archive log, to 
# aid in troubleshooting.  It ignores a folder named "Archive" within the folder that was copied, in case it exists.
echo 'Zipping files'
7z a "${LOCAL_BACKUP_FOLDER}/Day1/${APPLICATION_NAME}_Backup_${BACKUP_DATE}.zip" -xr!$APPLICATION_NAME/Archive $LOCAL_TEMP_FOLDER > "$LOCAL_BACKUP_FOLDER/Day1/Archive.Log"

# Excludes the \Archive and \Weekly folders in the destination folder so they 
# aren't overwritten during the mirror operation.  ALso creates a log in the
# destination folder.

if ! [ -d $BACKUP_DESTINATION ]; then 
  echo "Creating remote backup folder"
  mkdir -p $BACKUP_DESTINATION
fi

echo 'Mirror to the remote backup folder'
rsync -rz4vt --delete --exclude 'rsync.log' --exclude 'Archive' --exclude 'Weekly' $LOCAL_BACKUP_FOLDER/ $BACKUP_DESTINATION > $BACKUP_DESTINATION/rsync.log
