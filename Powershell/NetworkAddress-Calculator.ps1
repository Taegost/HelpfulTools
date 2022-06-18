<#
.SYNOPSIS
  To determine network details with a defined subnet
.DESCRIPTION
  When given an IP address and subnet or mask length(CIDR notation), this script will calculate the Network 
  address, the beginning and ending IPs, and the Broadcast address.
.NOTES
  An IP address must be specified and either subnet mask or mask length, but not both.
.EXAMPLE
  NetworkAddress-Calculator -ip 192.168.1.1 -subnet 255.255.255.0
  NetworkAddress-Calculator -ip 192.168.1.1 -maskLength 24
#>

#============================ Initialization Section ============================
#Requires -Version 5.0

Param
(
  #Only valid IP addresses are accepted
  [Parameter(
    Mandatory=$true,
    HelpMessage = "Must be a valid IP address"
  )]
  [IpAddress]$ip,
  [Parameter(
    Mandatory=$true,
    ParameterSetName="Subnet"
  )]
  [IpAddress]$subnet,
  [Parameter(
    Mandatory=$true,
    ParameterSetName="CIDR",
    HelpMessage = "Network mask length, must be between 1-31"
  )]
  [ValidateRange(1,31)]
  [Alias("CIDR")]
  [int]$maskLength
)

#============================ Class Section ============================
class IpDetails
{
  [IpAddress]$ip
  hidden [string]$ipBinary = ""
  [IpAddress]$subnet
  hidden [string]$subnetBinary = ""
  [int]$maskLength
  [IpAddress]$networkId
  [IpAddress]firstNetworkAddress
  [IpAddress]lastNetworkAddress
  [IpAddress]broadCastAddress

  IpDetails([IpAddress]$inIp, [IpAddress]$inSubnet)
  {
    $this.ip = $inIp 
    $this.ipBinary = [IpDetails]::IpToBinary($this.ip)
    $this.subnet = $inSubnet
    $this.subnetBinary = [IpDetails]::IpToBinary($this.subnet)
    $this.maskLength = $this.subnetBinary.IndexOf("0")
    [IpDetails]::CalculateNetworkInformation()
  } # subnet constructor

  IpDetails([IpAddress]$inIp, [int]$maskLength)
  {
    $this.ip = $inIp 
    $this.ipBinary = [IpDetails]::IpToBinary($this.ip)
    $this.maskLength = $maskLength
    $this.subnetBinary = [string].PadRight(($this.maskLength - 1), "1").PadRight(32, "0")
    $this.subnet = [IpDetails]::BinaryToIp($this.subnetBinary)
    [IpDetails]::CalculateNetworkInformation()
  } # CIDR constructor

  private [void]CalculateNetworkInformation()
  {
    $this.networkID = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$this.maskLength).padright(32,"0"))
    $this.firstNetworkAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(31,"0") + "1")
    $this.lastNetworkAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(31,"1") + "0")
    $this.broadCastAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(32,"1"))
  } # method CalculateNetworkInformation

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
} # class IpDetails

#============================ Main Section ============================
[IpDetails]::new($ip, $subnet)
