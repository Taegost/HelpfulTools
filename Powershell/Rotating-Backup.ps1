#==============================================================================
# SCRIPT PURPOSE:		  To keep a rotating backup of a specified folder
#                       
# CREATE DATE: 			  6/7/2022
# CREATE AUTHOR(S):		Mike Wheway
# LAST MODIFY DATE:		6/7/2022
# LAST MODIFY AUTHOR:	Mike Wheway
# RUN SYNTAX:			    ./Rotating-Backup.ps1
#
#
# COMMENT: This script has 2 stages: 1st stage creates a local backup on the
#         machine, then the 2nd stage mirrors those backups to a remote 
#         location
#           
# PRE-REQS: 7-Zip is a pre-req to archive the files, you need to make sure it's 
#          installed and accessible from the command shell before using.
#------------------------------------------------------------------------------

# --== As always, make sure you test that it works before trusting it ==--

#============================Initialization Section============================

# Set variables
# It is best to avoid spaces whenever possible