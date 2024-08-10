# A script used to parse duplicate files from Unraid Mover logs
$inFilePath = "C:\Temp\Dupe_Cache\raw.txt"
$outFilePath = "C:\Temp\Dupe_Cache\processed.txt"
$regex = '(?<=move_object:).*?(?=File exists)'
$files = @()

# Read the file line by line
Get-Content $inFilePath | ForEach-Object {
  $line = $_

  # Apply the regex to the line
  if ($line -match $regex) {
    $extractedSubstring = $matches[0].Trim()

    # Do something with the extracted sub-string
    if ($files -notcontains $extractedSubstring)
    {
      $files += $extractedSubstring
    }
  }
}

Out-File -FilePath $outFilePath -InputObject $files
$files