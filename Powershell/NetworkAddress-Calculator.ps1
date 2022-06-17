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
.LASTMODIFIED
  6/17/2022 by Mike Wheway
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
  [string]$ipBinary = ""
  [IpAddress]$subnet
  hidden [string]$subnetBinary = ""
  [int]$netbits
  [string]$networkId

  IpDetails([string]$inIp, [string]$inSubnet)
  {
    if ($inIp.Contains("/")) # We assume it's CIDR format
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

      # If the subnet is 0.0.0.0 or 255.255.255.255, we need to adjust the logic.
      if (($this.subnetBinary.Contains("0")) -and ($this.subnetBinary.Contains("1")))
        { $this.netBits = $this.subnetBinary.IndexOf("0") }
      elseif ($this.subnetBinary.Contains("0"))
        { $this.netBits = 0 }
      else
        { $this.netBits = 32 }
    } # if ($inIp.Contains("/"))
    $this.ipBinary = [IpDetails]::IpToBinary($this.ip)
    $this.networkID = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$this.netBits).padright(32,"0"))
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
    $bits = $this.netbits #Using this.netbits directly causes problems in the return

    # Identify subnet boundaries
    
    $firstAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(31,"0") + "1")
    $lastAddress = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(31,"1") + "0")
    $broadCast = [IpDetails]::BinaryToIp($this.ipBinary.substring(0,$bits).padright(32,"1"))

    $returnStr =  "Network ID:`t$this.networkID/$bits
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