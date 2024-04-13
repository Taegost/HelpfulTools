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
    $subFolders = (Get-ChildItem $folder -Directory).FullName
    if ($subFolders)
    {
        Write-Output "Processing sub-folders first"
        foreach ($subfolder in $subfolders) { Use-Folder $subfolder }
    }
    else
    {
        Write-Output "There are no sub-folders"
    }
    
    $files = (Get-ChildItem $folder -File).FullName
    foreach ($file in $files)
    {
        Copy-File $file
    }
}

function Copy-File ([string]$file)
{
    Write-Output "Processing file: $file"
    $extension = (Split-Path $file -Leaf).Split(".")[-1]
    if ($validExtensions -contains $extension)
    {
        Write-Output "Valid video file, copying"
        Copy-Item -Path $file -Destination $destinationFolder
    }
    else
    {
        Write-Output "Not a valid video file, skipping"
    }
}

$validExtensions = @("WMV","MKV","MPG","MPEG","MP4","FLV","AVI","divx","m2ts","mov","ts","wmv","xvid")

$destinationFolder = "\\phoenix.local\Multimedia\Torrent Files\Encode"
Write-Output "Path: $path"
Write-Output "Name: $name"
Write-Output "Destination: $destinationFolder"

$testPath = Join-Path $path $name
$isDirectory = (Get-Item $testPath).PSIsContainer

#$isDirectory = Test-Path -Path $childPath -PathType Container
#$isDirectory = $false
if ($isDirectory)
{
    $fullPath = $path
    Use-Folder $fullPath
}
else
{
    $fullPath = $testPath
    Copy-File $fullPath
}

Stop-Transcript