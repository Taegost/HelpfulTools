' Every 60 seconds, presses the F15 (unused) key to ensure the system stays active
' Can be put in the Startup folder (C:\Users\[User Name]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup) to run automatically
Dim objResult

Set objShell = WScript.CreateObject("WScript.Shell")    

Do While True
  objResult = objShell.sendkeys("{F15}")
  Wscript.Sleep (60000)
Loop