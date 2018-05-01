#==============================================================================
# SCRIPT PURPOSE:		Queries 
#                       
# CREATE DATE: 			
# CREATE AUTHOR(S):		Michael J. Butler
# LAST MODIFY DATE:		
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
param($ComputerName)
$importpath = "c:\serverutilities\Test-Server.txt"
$ErrorActionPreference = "SilentlyContinue"
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
    $script:computername = Get-Content $importpath
}

Function Test-Server{
[cmdletBinding()]
param(
	[parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[string[]]$ComputerName,
	[parameter(Mandatory=$false)]
	[switch]$CredSSP,
	[Management.Automation.PSCredential] $Credential)
	
begin{
	$total = Get-Date
	$results = @()
	if($credssp){if(!($credential)){Write-Host "must supply Credentials with CredSSP test";break}}
}
process{
    foreach($name in $computername)
    {
	$dt = $cdt= Get-Date
	Write-verbose "Testing: $Name"
	$failed = 0
	try{
	$DNSEntity = [Net.Dns]::GetHostEntry($name)
	$domain = ($DNSEntity.hostname).replace("$name.","")
	$ips = $DNSEntity.AddressList | %{$_.IPAddressToString}
	}
	catch
	{
		$rst = "" |  select Name,IP,Domain,Ping,WSMAN,CredSSP,RemoteReg,RPC,RDP,Uptime,Log
		$rst.name = $name
		$results += $rst
		$failed = 1
	}
	Write-verbose "DNS:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
	if($failed -eq 0){
	foreach($ip in $ips)
	{
	    
		$rst = "" |  select Name,IP,Domain,Ping,WSMAN,CredSSP,RemoteReg,RPC,RDP,Uptime,Log
	    $rst.name = $name
		$rst.ip = $ip
		$rst.domain = $domain
		####RDP Check (firewall may block rest so do before ping
		try{
            $socket = New-Object Net.Sockets.TcpClient($name, 3389)
		  if($socket -eq $null)
		  {
			 $rst.RDP = $false
		  }
		  else
		  {
			 $rst.RDP = $true
			 $socket.close()
		  }
       }
       catch
       {
            $rst.RDP = $false
       }
		Write-verbose "RDP:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
        #########ping
	    if(test-connection $ip -count 1 -Quiet)
	    {
	        Write-verbose "PING:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
			$rst.ping = $true
			try{############wsman
				Test-WSMan $ip | Out-Null
				$rst.WSMAN = $true
				}
			catch
				{$rst.WSMAN = $false}
				Write-verbose "WSMAN:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
			if($rst.WSMAN -and $credssp) ########### credssp
			{
				try{
					Test-WSMan $ip -Authentication Credssp -Credential $cred
					$rst.CredSSP = $true
					}
				catch
					{$rst.CredSSP = $false}
				Write-verbose "CredSSP:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
			}
			try ########remote reg
			{
				[Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $ip) | Out-Null
				$rst.remotereg = $true
			}
			catch
				{$rst.remotereg = $false}
			Write-verbose "remote reg:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
			try ######### wmi
			{	
				$w = gwmi win32_computersystem -ComputerName $name -ErrorAction Stop
				$rst.RPC = $true
			}
			catch
				{$rst.rpc = $false}
			Write-verbose "WMI:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)" 
            try ######### uptime
            {
            $wmi = Get-WmiObject -ComputerName $name -Class Win32_OperatingSystem
            $uptime = ($wmi.ConvertToDateTime($wmi.LocalDateTime) – $wmi.ConvertToDateTime($wmi.LastBootUpTime))
            $rst.uptime = [string]( $uptime.Days, 'days', $uptime.Hours, 'hours', $uptime.Minutes, 'minutes')
            }
            catch
				{$rst.uptime = $false}
            Write-verbose "UPTIME:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
            try ######### Last Shutdown Log
            {
            $StartTime = (Get-Date).AddDays(-7)
            $User32 = Get-WinEvent -FilterHashtable @{Logname="System"; ProviderName="USER32"; StartTime=$StartTime}  -ComputerName "$name" -MaxEvents 1
            $rst.log = ($user32.TimeCreated,$User32.Message)
            }
            catch
                {$rst.log = $false}
            Write-verbose "BOOT LOG:  $((New-TimeSpan $dt ($dt = get-date)).totalseconds)"
	    }
		else
		{
			$rst.ping = $false
			$rst.wsman = $false
			$rst.credssp = $false
			$rst.remotereg = $false
			$rst.rpc = $false
            $rst.uptime = $false
            $rst.log = $false
		}
		$results += $rst	
	}}
	Write-Verbose "Time for $($Name): $((New-TimeSpan $cdt ($dt)).totalseconds)"
	Write-Verbose "----------------------------"
}
}
end{
	Write-Verbose "Time for all: $((New-TimeSpan $total ($dt)).totalseconds)"
	Write-Verbose "----------------------------"
return $results
}
}

#========================== MAIN PROCESSING SECTION ===========================


# If not defined in the parameters, Load the Notepad with server list test file to edit.


if (! $ComputerName){$Computername = Read-Host "Enter Server Name - or leave blank to open editor for multiple servers"}
if (! $ComputerName){edit-server-list}
$gridview = read-host "Would you like the results in Grid View?" 

if ($gridview -like "y*" ){
    Test-Server $ComputerName -Verbose | Out-GridView
}
else { 
    Test-Server $ComputerName
}