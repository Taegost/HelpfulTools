$sonarrAPI = "YOURAPIKEY"
$sonarrURL = "http://IPAddress:Port"
$parseFolder = "C:\Your\Folder\Here"

$filelist = Get-ChildItem "$parseFolder" -Filter *.*

ForEach ($file in $filelist){ 
    $url = "$sonarrURL/api/command" 
    $json1 = "{ ""name"": ""downloadedepisodesscan"",""path"": """ 
    $json2 = """}" 
    #$encoded = $file.DirectoryName + "\" + $file.BaseName + $file.Extension; 
    $escaped = $file.FullName.replace('\','\\') 
    $jsoncomplete = $json1 + $escaped + $json2        
    Invoke-RestMethod -Uri $url -Method Post -Body $jsoncomplete -Headers @{"X-Api-Key"="$sonarrAPI"} 
}