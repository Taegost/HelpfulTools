#==============================================================================
# SCRIPT PURPOSE:		Used to compare the IP address of a hostname with the 
#                 current external IP address of the machine the script is
#                 running on.
#                       
# CREATE DATE: 			  10/24/20
# CREATE AUTHOR(S):		Mike Wheway
# LAST MODIFY DATE:		10/24/20
# LAST MODIFY AUTHOR:	Mike Wheway
# RUN SYNTAX:			-domain (hostname)
#
# COMMENT: If you have a specific hostname that you'll be checking all the 
#         time, than set it as the default domain in the Param declaration.
#           
#
#------------------------------------------------------------------------------
Param
(
  [string]$domain = "google.com"
)

$ping = New-Object System.Net.NetworkInformation.Ping
$domainIp = $($ping.Send($domain).Address).IPAddressToString

$externalIp = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()

Write-Output "Domain: $domainIp"
Write-Output "External: $externalIp"
If ($domainIp -eq $externalIp) 
{ Write-Output "The IP addresses match" }
else 
{ Write-Host "The IP addresses DON'T match" }