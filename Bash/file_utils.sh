# This script is not meant to be executed, it just contains a bunch of one-liners used for file manipulation

# Get the total file size of all files within a directory (and it's sub-directories) that meet the criteria
find -type f -name '*.photon?' -exec du -ch {} + | grep total$

# Delete all files within a directory (and it's sub-directories) that meet the criteria
find -type f -name '*.photon?' -exec rm {} +