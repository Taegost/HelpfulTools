#!/bin/bash
# Use this script to make backups of important folders.  It has 2 stages: 1st
# stage creates a local backup on the machine, then the 2nd stage mirrors those
# backups to a remote location

# 7-Zip is a pre-req to archive the files, you need to make sure it's installed
# and accessible from the command shell before using.
# As always, make sure you test that it works before trusting it.

# Set variables
# It is best to avoid spaces whenever possible
APPLICATION_NAME="SampleApplication"
SERVER_FOLDER="/path/to/folders"
LOCAL_BACKUP_FOLDER="/backups/$APPLICATION_NAME"
LOCAL_TEMP_FOLDER="/tmp/$APPLICATION_NAME"
BACKUP_DESTINATION="//RemoteFileServer/Backups/$APPLICATION_NAME"
ROTATE_DAYS=5

# Uses the date format YYYY-MM-DD (ex. 2019-07-23)
BACKUP_DATE=$(date +%F)

echo 'Switch to the backup folder'

cd $LOCAL_BACKUP_FOLDER

# This keeps 5 days of backups.  To keep more, just modify this section
# This may generate errors during the first few runs, but they can be safely
# ignored as long as you know the folders really don't exist.
echo 'In case the the folders already exist, rotate them'
last_folder="$LOCAL_BACKUP_FOLDER/Day$ROTATE_DAYS"
if [ -d "$last_folder" ]; then 
  rm -Rf $last_folder
fi
for count in $(seq 1 $(ROTATE_DAYS-1)); do 
  mv "$LOCAL_BACKUP_FOLDER/Day$ROTATE_DAYS" "$LOCAL_BACKUP_FOLDER/Day$(ROTATE_DAYS+1)"
done

mkdir -p "Day1"

# It's important to copy the files first because if any of them are in use
# at the time 7-Zip tries to archive them, they will most likely be skipped.
echo 'Copying the files to a temporary location'
if [ -d "$LOCAL_TEMP_FOLDER" ]; then 
  rm -Rf $LOCAL_TEMP_FOLDER
fi
cp -r $SERVER_FOLDER $LOCAL_TEMP_FOLDER

# In addition to creating the archive, it also creates an archive log, to 
# aid in troubleshooting
echo 'Zipping files'
7z a "$LOCAL_BACKUP_FOLDER/Day1/$APPLICATION_NAME_Backup_$BACKUP_DATE.zip" -xr!$APPLICATION_NAME/Archive $LOCAL_TEMP_FOLDER > "$LOCAL_BACKUP_FOLDER/Day1/Archive.Log"

# Excludes the \Archive and \Weekly folders in the destination folder so they 
# aren't overwritten during the mirror operation.  ALso creates a log in the
# destination folder.
echo 'Mirror to the backup folder on the fileserver'
Robocopy "%LOCAL_DRIVE%%LOCAL_BACKUP_FOLDER%" "%BACKUP_DESTINATION%" /XD "%BACKUP_DESTINATION%\Weekly" "%BACKUP_DESTINATION%\Archive" /MIR /COPY:DT /FFT /LOG:"%BACKUP_DESTINATION%\Robocopy.Log" 