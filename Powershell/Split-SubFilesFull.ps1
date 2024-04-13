[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$path

)
Start-Transcript -Path "C:\Scripts\Split-SubFiles.log" -Append
$destinationFolder = "\\phoenix.local\Multimedia\Torrent Files\Encode"

Write-Output "Processing root: $path"

$children = (Get-ChildItem $path)
foreach ($child in $children)
{
    $childPath = $child.FullName
    Write-Output "Processing child: $childPath"
    $isDirectory = Test-Path -Path $childPath -PathType Container
    if ($isDirectory) 
    {
        $files = (Get-ChildItem $childPath -File)
        foreach ($file in $files)
        {
            $filePath = $file.FullName
            $testPath = Join-Path $destinationFolder $file
            if (Test-Path $testPath)
            {
                Write-Output "File already exists in destination, skipping"
            }
            else 
            {
                Write-Output "Copying: $filePath"
                Copy-Item -Path $filePath -Destination $destinationFolder
            }
        }
    }
    else
    {
        $testPath = Join-Path $destinationFolder $child
        if (Test-Path $testPath)
        {
            Write-Output "File already exists in destination, skipping"
        }
        else 
        {
            Write-Output "Copying: $childPath"
            Copy-Item -Path $childPath -Destination $destinationFolder
        }
    }
}

Stop-Transcript