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
  [parameter(Position=0)]  
  $ip = "0.0.0.0",
  [parameter(Position=1)]  
  $subnet = "255.255.255.0"
)

#============================ Functions Section ============================

Function IpToBinary ($ipAddress)
{
  $ipAddress.split(".") | %{$binary=$binary + $([convert]::toString($_,2).padleft(8,"0"))}
  return $binary
} # function IpToBinary

Function BinaryToIp ($binary)
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
  Return ((IsBinaryValid $data) -or ($ipBinary.substring($netBits) -eq "00000000") -or ($ipBinary.substring($netBits) -eq "11111111"))
} # Function IsIpValid

Function IsSubnetValid ($data)
{
  Return ((IsBinaryValid $data) -or ($smBinary.substring($netBits).contains("1") -eq $true))
} # Function IsSubnetValid

#============================ Main Section ============================
$ipBinary = IpToBinary $ip
$snBinary = IpToBinary $subnet
$netBits=$snBinary.indexOf("0")

# Identify subnet boundaries
$networkID = BinaryToIp $($ipBinary.substring(0,$netBits).padright(32,"0"))
$firstAddress = BinaryToIp $($ipBinary.substring(0,$netBits).padright(31,"0") + "1")
$lastAddress = BinaryToIp $($ipBinary.substring(0,$netBits).padright(31,"1") + "0")
$broadCast = BinaryToIp $($ipBinary.substring(0,$netBits).padright(32,"1"))

# Write output
"`n   Network ID:`t$networkID/$netBits"
"First Address:`t$firstAddress"
" Last Address:`t$lastAddress"
"    Broadcast:`t$broadCast`n"