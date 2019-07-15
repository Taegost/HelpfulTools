#!/bin/bash

# This script is meant to be used in conjunction with the Rotating Backup script.  It's intention is to save 1 backup
# per week into a separate folder that can then be used to roll back to a point in time prior to the last week.

BACKUP_LOCATION="//RemoteFileServer/Backups/" # Update this location to wherever your backups are stored.
CURRENT_DATE=$(date +%F) # Uses the date format YYYY-MM-DD (ex. 2019-07-23)

save_backup () {
  app_name=$1
  app_location="${BACKUP_LOCATION}${app_name}"
  app_first_day="${app_location}/Day1"
  app_weekly="${app_location}/Weekly"
  if ! [ -d $app_location ]; then
    echo "Application folder not found: ${app_location}"
    return 1
  fi
  if ! [ -d $app_first_day ]; then
    echo "Backup folder not found: ${app_first_day}"
    return 1
  fi
  if ! [ -d $app_weekly ]; then
    mkdir -p $app_weekly
  fi
  app_current_location="${app_weekly}/${CURRENT_DATE}"
  cp -r -p $app_first_day $app_current_location
  echo "Backup saved for ${app_name}"
  return 0
} # function save_backup

# Uncomment the below lines and change the app names to fit your needs.  Add as many lines as needed.
# save_backup App1
# save_backup App2