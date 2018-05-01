
#==============================================================================
# SCRIPT PURPOSE:		
#                       
# CREATE DATE: 			5/1/2018
# CREATE AUTHOR(S):		Michael J. Butler
# LAST MODIFY DATE:		5/1/2018
# LAST MODIFY AUTHOR:	Michael J. Butler
# RUN SYNTAX:			./checkversion.ps1 -server (servername)
#
#
# COMMENT:  This script will prompt the user for the serve rname and their credentials
#           then connect to the server and return the Windows OS version name
#           (ex. "Microsoft Windows Server 2008 R2 Enterprise")
#           
#
#------------------------------------------------------------------------------

#============================Initialization Section============================

# Load the parameters. Not required as it will prompt for them as well.
param($servers)
$importpath = ($env:USERPROFILE+"\checkver.txt")
#$ErrorActionPreference = "SilentlyContinue"
#$error.clear()

#========================Functions and Filters Section=========================

#------------------------- FUNCTION EDIT-SERVER-LIST --------------------------
# The Edit Server List function brings up the server text file for multiple servers
# Leave it blank if you want to just enter one server
# You have two minutes. Close all other Notepads.

function edit-server-list {

    if (!(Test-Path $importpath))
    {
        New-Item $importpath -ItemType "file" | out-null
    }
    NOTEPAD.EXE $importpath

    Wait-Process -name notepad -timeout 120

    # Reads in the Server List. 
    $script:servers = Get-Content $importpath
}

#========================== MAIN PROCESSING SECTION ===========================


# If not defined in the parameters, Load the Notepad with server list test file to edit.


if (! $servers){$servers = Read-Host "Enter Server Name - or leave blank to open editor for multiple servers"}
if (! $servers){edit-server-list}
$credential = Get-Credential

foreach ($server in $servers) {
$OScheck = (Get-WmiObject -comp $server -Credential $credential -Class Win32_OperatingSystem).Caption
Write-Output $server $OScheck
}
