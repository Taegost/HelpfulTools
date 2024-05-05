[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$path,

    [Parameter(Mandatory=$true)]
    [string]$name
)
Start-Transcript -Path "C:\Scripts\Split-SubFiles.log" -Append

function Use-Folder([string]$folder)
{
    Write-Output "Processing directory: $folder"
    $subFolders = (Get-ChildItem -LiteralPath $folder -Directory).FullName
    if ($subFolders)
    {
        Write-Output "Processing sub-folders first"
        foreach ($subfolder in $subfolders) { Use-Folder $subfolder }
    }
    else
    {
        Write-Output "There are no sub-folders"
    }
    
    $files = (Get-ChildItem -LiteralPath $folder -File).FullName
    foreach ($file in $files)
    {
        Copy-File $file
    }
}

function Copy-File ([string]$file)
{
    Write-Output "Processing file: $file"
    $fileName = (Split-Path $file -Leaf)
    $filePath = (Split-Path $file -Parent)
    $extension = $fileName.Split(".")[-1]
    if ($validExtensions -contains $extension)
    {
        Write-Output "Valid video file, copying"

        # Alternate between two folders
        $pathOneCount = (Get-ChildItem -LiteralPath $destinationFolderOne).Count
        $pathTwoCount = (Get-ChildItem -LiteralPath $destinationFolderTwo).Count
        if ($pathOneCount -lt $pathTwoCount)
        {
            $destinationFolder = $destinationFolderOne
        }
        else
        {
            $destinationFolder = $destinationFolderTwo
        }
        Write-Output "Destination: $destinationFolder"
        
        Robocopy "$filePath" "$destinationFolder" "$fileName" /mt /z /njh /xn /xo
    }
    else
    {
        Write-Output "Not a valid video file, skipping"
    }
}

$validExtensions = @("WMV","MKV","MPG","MPEG","MP4","FLV","AVI","divx","m2ts","mov","ts","wmv","xvid")
$destinationFolderOne = "\\phoenix.local\Multimedia\Torrent Files\Encode"
$destinationFolderTwo = "\\phoenix.local\Multimedia\Torrent Files\Encode2"

Write-Output "Current time: $(Get-Date)"
Write-Output "Path: $path"
Write-Output "Name: $name"

Write-Output "Pausing for 60 seconds before continuing"
Start-Sleep -Seconds 60

#$testPath = Join-Path $path $name
if (Test-Path -LiteralPath $path -PathType Leaf)
{
    Copy-File $path
}
elseif (Test-Path -LiteralPath $path -PathType Container)
{
    Use-Folder $path
}
else 
{
    Write-Error "Unknown path type"
}

Stop-Transcript