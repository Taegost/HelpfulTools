#==============================================================================
# SCRIPT PURPOSE:		  To determine CIDR notation and network addresses from a
#                     subnet.
#                       
# CREATE DATE: 			  6/10/2022
# CREATE AUTHOR(S):		Mike Wheway
# LAST MODIFY DATE:		6/10/2022
# LAST MODIFY AUTHOR:	Mike Wheway
# RUN SYNTAX:			    ./NetworkAddress-Calculator.ps1 -ip x.x.x.x -subnet x.x.x.x
#
#
# COMMENT: When given an IP address and subnet, this script will calculate the
#         Network ID in CIDR format, the beginning and ending IPs, and the
#         Broadcast address.
#           
#------------------------------------------------------------------------------
# --== As always, make sure you test that it works before trusting it ==--

#============================ Initialization Section ============================

Param
(
  [parameter(Mandatory)]
  [IpAddress]$ip = "0.0.0.0",
  [parameter()]
  [IpAddress]$subnet = ""
)

#============================ Functions Section ============================

Function IpToBinary ([string]$ipAddress)
{
  $ipAddress.split(".") | ForEach-Object{$binary=$binary + $([convert]::toString($_,2).padleft(8,"0"))}
  return $binary
} # function IpToBinary

Function BinaryToIp ([string]$binary)
{
  do {$ipAddress += "." + [string]$([convert]::toInt32($binary.substring($i,8),2)); $i+=8 } while ($i -le 24)
  return $ipAddress.substring(1)
} # Function BinaryToIp

Function IsBinaryValid ($data)
{
  Return $data.Length -eq 32
} # Function ValidateBinary

Function IsIpValid ($data)
{
  Return (IsBinaryValid $data)
} # Function IsIpValid

Function IsSubnetValid ($data)
{
  Return ((IsBinaryValid $data) -and ($data.contains("0") -eq $true))
} # Function IsSubnetValid

#============================ Main Section ============================
$ipBinary = IpToBinary $ip
if (!(IsIpValid $ipBinary))
{
  Write-Output "IP address is not valid: $ip"
  Return
}
$snBinary = IpToBinary $subnet
if (!(IsSubnetValid $snBinary))
{
  Write-Output "Subnet Mask is not valid: $subnet"
  Return
}
$netBits=$snBinary.indexOf("0")


# Identify subnet boundaries
$networkID = BinaryToIp $($ipBinary.substring(0,$netBits).padright(32,"0"))
$firstAddress = BinaryToIp $($ipBinary.substring(0,$netBits).padright(31,"0") + "1")
$lastAddress = BinaryToIp $($ipBinary.substring(0,$netBits).padright(31,"1") + "0")
$broadCast = BinaryToIp $($ipBinary.substring(0,$netBits).padright(32,"1"))

# Write output
Write-Output "`n   Network ID:`t$networkID/$netBits"
"First Address:`t$firstAddress"
" Last Address:`t$lastAddress"
"    Broadcast:`t$broadCast`n"