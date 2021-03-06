#==============================================================================
# SCRIPT PURPOSE:		Return the uptime of a server or list of servers.
#                       
# CREATE DATE: 			UNKNOWN
# CREATE AUTHOR(S):		Michael J. Butler
# LAST MODIFY DATE:		11/12/2012 1:38am EST
# LAST MODIFY AUTHOR:	Michael J. Butler
# RUN SYNTAX:			-server (servername)
#
#
# COMMENT:  
#           
#
#------------------------------------------------------------------------------

#============================Initialization Section============================

# Load the parameters. Not required as it will prompt for them as well.
param($servers)
$importpath = "c:\serverutilities\SrvUptime.txt"
#$ErrorActionPreference = "SilentlyContinue"
#$error.clear()

#========================Functions and Filters Section=========================

#------------------------- FUNCTION EDIT-SERVER-LIST --------------------------
# The Edit Server List function brings up the server text file for multiple servers
# Leave it blank if you want to just enter one server
# You have two minutes. Close all other Notepads.

function edit-server-list {

    NOTEPAD.EXE $importpath

    Wait-Process -name notepad -timeout 120

    # Reads in the Server List. 
    $script:servers = Get-Content $importpath
}

#========================== MAIN PROCESSING SECTION ===========================


# If not defined in the parameters, Load the Notepad with server list test file to edit.

if (! $servers){$servers = Read-Host "Enter Server FQDN - or leave blank to open editor for multiple servers"}
if (! $servers){edit-server-list}
$credential = Get-Credential

foreach ($server in $servers) {
    $testcon = test-connection -ComputerName $server -quiet
    if ($testcon -eq $true) {
      $wmi = Get-WmiObject -ComputerName $server -Class Win32_OperatingSystem -Credential $credential 
      $uptime = ($wmi.ConvertToDateTime($wmi.LocalDateTime) – $wmi.ConvertToDateTime($wmi.LastBootUpTime))
      write-host "$server has been up "$uptime.Days "days" $uptime.Hours "hours" $uptime.Minutes "minutes"
    }
    else {
      write-host "$server is not reachable at this time"
    }
}