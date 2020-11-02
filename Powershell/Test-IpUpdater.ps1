#==============================================================================
# SCRIPT PURPOSE:		Used to compare the IP address of a hostname with the 
#                 current external IP address of the machine the script is
#                 running on.
#                       
# CREATE DATE: 			  10/24/20
# CREATE AUTHOR(S):		Mike Wheway
# LAST MODIFY DATE:		11/2/20
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
  [parameter(Position=0)]  
  [string]$domain = "google.com"
)

$domainIp = [System.Net.Dns]::GetHostAddresses($domain)[0].IPAddressToString;

$externalIp = (Invoke-WebRequest ifconfig.me/ip).Content.Trim()

Write-Output "Domain Name: $domain"
Write-Output "Domain IP: $domainIp"
Write-Output "External IP: $externalIp"

If ($domainIp -eq $externalIp) 
{ Write-Output "The IP addresses match" }
else 
{ Write-Host "The IP addresses DON'T match" }