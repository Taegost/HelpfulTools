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
#Requires -Version 5.0

Param
(
  [Parameter()]
  [string]$ip,
  [Parameter()]
  [string]$subnet
)

#============================ Class Section ============================
class IpDetails
{
  [IpAddress]$ip
  [string]$ipBinary = ""
  [IpAddress]$subnet
  [string]$subnetBinary = ""
  [int]$netbits

  IpDetails([string]$inIp, [string]$inSubnet)
  {
    if ($inIp.Contains("/"))
    {
      $splitIp = $inIp.Split("/")
      $this.ip = $splitIp[0]
      $this.netbits = $splitIp[1]
      $this.subnetBinary = $this.subnetBinary.PadRight(($this.netbits - 1), "1").PadRight(32, "0")
      $this.subnet = [IpDetails]::BinaryToIp($this.subnetBinary)
    }
    else 
    { 
      $this.ip = $inIp 
      $this.subnet = $inSubnet
      $this.subnetBinary = [IpDetails]::IpToBinary($this.subnet)
      $this.netBits = $this.subnetBinary.IndexOf("0")

    } # if ($inIp.Contains("/"))
    $this.ipBinary = [IpDetails]::IpToBinary($this.ip)
  } # constructor

  static [string]IpToBinary ([IpAddress]$ipAddress)
  {
    [string]$binary = ""
    $ipAddress.ToString().Split(".") | ForEach-Object{$binary=$binary + $([convert]::toString($_,2).padleft(8,"0"))}
    return $binary
  } # method IpToBinary

  static [IpAddress]BinaryToIp ([string]$binary) 
  {
    [int]$i = 0
    do {$ipAddress += "." + [string]$([convert]::toInt32($binary.substring($i,8),2)); $i+=8 } while ($i -le 24)
    return $ipAddress.substring(1)
  } # method BinaryToIp
  
  [string]ToString()
  {
    $bits = $this.netbits #Using this.netbits directly causes problems in the return string

    # Identify subnet boundaries
    $networkID = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(32,"0"))
    $firstAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(31,"0") + "1")
    $lastAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(31,"1") + "0")
    $broadCast = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(32,"1"))

    $returnStr =  "Network ID:`t$networkID/$bits
First Address:`t$firstAddress
Last Address:`t$lastAddress
Broadcast:`t$broadCast"
    return $returnStr
  } # method ShowNetworkBoundaries
} # class IpDetails

#============================ Main Section ============================
[IpDetails]$validator = [IpDetails]::new($ip, $subnet)
$validator
$validator.ToString()