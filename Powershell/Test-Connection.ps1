#==============================================================================
# SCRIPT PURPOSE:		Repeats a ping check until it is successful. Useful for
#                       determining when a server comes back online.
# CREATE DATE: 			
# CREATE AUTHOR(S):		Michael J. Butler 
# LAST MODIFY DATE:		
# LAST MODIFY AUTHOR:	Mike Wheway 
# RUN SYNTAX:			-server (servername)
#
#
# COMMENT:  
#           
#
#------------------------------------------------------------------------------

#============================Initialization Section============================

# Load the parameters. Not required as it will prompt for them as well.
param($server)
$sound = new-object system.media.soundplayer("c:\Windows\Media\chimes.wav")

#========================== MAIN PROCESSING SECTION ===========================
$fromEmail = 'ConnectionTesting@example.com'
$smtpServer = 'smtp.example.com'
$server = Read-Host "Enter Server Name :"
$email = read-host "Enter Email Address. Leave Blank for no Email Notification :"
while ((test-connection -computer $server -count 1 -delay 1 -quiet) -ne "TRUE") {
  write-host "." -NoNewline
  Wait-Event -Timeout 10}
$sound.Play()
write-host "$server is back online" -ForegroundColor Green   
if ($email -ne ""){
Send-MailMessage -from $fromEmail -to $email -subject "$server is now pingable" -Body "This is your notification that the system at $server is now reachable. `nThanks!" -SmtpServer $smtpServer
}
