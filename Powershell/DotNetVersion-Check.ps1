  # These values are found here: https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed
  
  $releaseKey = Get-ChildItem 'HKLM:\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v4\\Full\\' | Get-ItemPropertyValue -Name Release
  if ($releaseKey -ge 528049) { return "4.7.8 or higher" }
  if ($releaseKey -ge 528040) { return "4.7.8" }
  if ($releaseKey -ge 461814) { return "4.7.2" }
  if ($releaseKey -ge 461808) { return "4.7.2" }
  if ($releaseKey -ge 461310) { return "4.7.1" }
  if ($releaseKey -ge 461308) { return "4.7.1" }
  if ($releaseKey -ge 460805) { return "4.7" }
  if ($releaseKey -ge 460798) { return "4.7" }
  if ($releaseKey -ge 394806) { return "4.6.2" }
  if ($releaseKey -ge 394802) { return "4.6.2" }
  if ($releaseKey -ge 394271) { return "4.6.1" }
  if ($releaseKey -ge 394254) { return "4.6.1" }
  if ($releaseKey -ge 393297) { return "4.6" }
  if ($releaseKey -ge 393295) { return "4.6" }
  if ($releaseKey -ge 379893) { return "4.5.2" }
  if ($releaseKey -ge 378758) { return "4.5.1" }
  if ($releaseKey -ge 378675) { return "4.5.1" }
  if ($releaseKey -ge 378389) { return "4.5" }
  # The code below should never execute. A non-null release key should mean that 4.5 or later is installed,
  # and a null key will throw an exception.
  return "No 4.5 or later version detected"
