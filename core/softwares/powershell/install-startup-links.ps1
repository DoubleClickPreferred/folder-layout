$WshShell = New-Object -comObject WScript.Shell

# Reference: https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-.net-and-com-objects--new-object-?view=powershell-7.4#creating-com-objects-with-new-object

# pageant shortcut
$Shortcut = $WshShell.CreateShortcut("$Env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\pageant.lnk");
$Shortcut.TargetPath = "C:\home\static\bin\putty-0.81\pageant.exe";
$Shortcut.Arguments = "PATH TO .ppk file";
$Shortcut.WindowStyle = 1;
$Shortcut.WorkingDirectory = "C:\home\static\bin\putty-0.81";
$Shortcut.Save();