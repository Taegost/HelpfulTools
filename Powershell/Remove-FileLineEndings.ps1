<#
.SYNOPSIS
  To parse text from Dungeons & Dragons-style documents to remove line endings
.DESCRIPTION
  When copy/pasting text from D&D-style documents, there are typically a lot of line breaks in the 
  middle of sentences. This script will remove those line breaks to make it easier to add to product
  descriptions when doing many at a time.
.NOTES
  A blank line is required between paragraphs so they don't all run together
#>
Param
(
  [parameter(Position=0)]
  [string]$inputFile = "c:\temp\input.txt",
  [parameter(Position=1)]
  [string]$outputFile = "c:\temp\output.txt"
)

$fileContent = (Get-Content "$inputFile")
$fileOutput = ""
$space = ""

foreach ($line in $fileContent)
{
    if ($line -ne "")
    {
        $fileOutput += "$space$line"
        $space = " "
    }
    else
    {
        $fileOutput += "`n`n"
        $space = ""
    }
}

Set-Content "$outputFile" -Value $fileOutput