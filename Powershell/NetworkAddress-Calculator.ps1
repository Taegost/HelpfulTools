<#
.SYNOPSIS
  To determine network address details for a defined IP and subnet.
.DESCRIPTION
  When given an IP address and subnet/mask length(CIDR notation), this script will calculate the Network 
  address, the beginning and ending IPs, and the Broadcast address.
.NOTES
  An IP address must be specified and either subnet mask or mask length, but not both.
.EXAMPLE
  NetworkAddress-Calculator -ip 192.168.1.1 -subnet 255.255.255.0
  NetworkAddress-Calculator -ip 192.168.1.1 -maskLength 24
#>

#region Initialization
#Requires -Version 5.0

Param
(
  # Base IP address to use for calculations (ex. 192.168.1.1)
  [Parameter(
    Mandatory=$true,
    HelpMessage = "Must be a valid IP address"
  )]
  [IpAddress]$ip,

  # Subnet mask to use for calculations (ex. 255.255.255.0). Can not be combined with maskLength
  [Parameter(
    Mandatory=$true,
    ParameterSetName="Subnet"
  )]
  [IpAddress]$subnet,

  # Netmask to use for calculations (ex. 24). Cannot be combined with subnet.
  # Valid values are 1-31
  [Parameter(
    Mandatory=$true,
    ParameterSetName="CIDR",
    HelpMessage = "Network mask length, must be between 1-31"
  )]
  [ValidateRange(1,31)]
  [Alias("CIDR")]
  [int]$maskLength
)
#endregion Initialization

#region Class
class IpDetails
{
  [IpAddress]$ip
  hidden [string]$ipBinary = ""
  [IpAddress]$subnet
  hidden [string]$subnetBinary = ""
  [int]$maskLength
  [IpAddress]$networkId
  [IpAddress]$firstNetworkAddress
  [IpAddress]$lastNetworkAddress
  [IpAddress]$broadCastAddress

  IpDetails([IpAddress]$inIp, [IpAddress]$inSubnet)
  {
    $this.ip = $inIp 
    $this.ipBinary = [IpDetails]::IpToBinary($this.ip)
    $this.subnet = $inSubnet
    $this.subnetBinary = [IpDetails]::IpToBinary($this.subnet)
    $this.maskLength = $this.subnetBinary.IndexOf("0")
    $this.CalculateNetworkInformation()
  } # subnet constructor

  IpDetails([IpAddress]$inIp, [int]$maskLength)
  {
    $this.ip = $inIp 
    $this.ipBinary = [IpDetails]::IpToBinary($this.ip)
    $this.maskLength = $maskLength
    $this.subnetBinary = "".PadRight(($this.maskLength - 1), "1").PadRight(32, "0")
    $this.subnet = [IpDetails]::BinaryToIp($this.subnetBinary)
    $this.CalculateNetworkInformation()
  } # CIDR constructor

  # Calculates and stores the network details based on the given IP and subnet
  [void]CalculateNetworkInformation()
  {
    [int]$bits = $this.maskLength # This is just to make the next lines shorter and more readable
    $this.networkID = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(32,"0"))
    $this.firstNetworkAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(31,"0") + "1")
    $this.lastNetworkAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(31,"1") + "0")
    $this.broadCastAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(32,"1"))
  } # method CalculateNetworkInformation

  # Converts an IP address into a binary notation string
  static [string]IpToBinary ([IpAddress]$ipAddress)
  {
    [string]$binary = ""
    $ipAddress.ToString().Split(".") | ForEach-Object{$binary=$binary + $([convert]::toString($_,2).padleft(8,"0"))}
    return $binary
  } # method IpToBinary

  # Converts a brinary notation string into an IP address
  static [IpAddress]BinaryToIp ([string]$binary)
  {
    [int]$i = 0
    do 
    {
      $ipAddress += "." + [string]$([convert]::toInt32($binary.substring($i,8),2))
      $i+=8 
    } while ($i -le 24)
    return $ipAddress.substring(1)
  } # method BinaryToIp
} # class IpDetails

#endregion Classs

#region Main
switch ($PSCmdlet.ParameterSetName)
{
  "Subnet" { [IpDetails]::new($ip, $subnet) }
  "CIDR"   { [IpDetails]::new($ip, $maskLength) }
  Default  { Write-Error "Invalid parameters given, please review Get-Help for this script"}
} # switch ($PSCmdlet.ParameterSetName)
#endregion Main

