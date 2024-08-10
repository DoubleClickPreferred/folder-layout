@echo off

set /P "input=Are you sure? (Y to confirm) "
   
if "%input%" == "Y" (
   REM find the drive letter of the backup device and copy the files of the C:\home
   for /f %%a in ('wmic logicaldisk where "VolumeName='BACKUP-KEYNAME'" get Caption ^| find ":"') do set letter=%%a

   if not defined letter (
      echo Backup drive cannot be found
   ) else (
      REM ensure that the db file holds the latest data (/Y = no confirmation on file override, /B = binary copy)
      copy /Y /B %letter%\home\duplicati\duplicati-db.sqlite C:\home\duplicati\duplicati-db.sqlite
      
      REM run Duplicati's restore
      "C:\Program Files\Duplicati 2\Duplicati.CommandLine.exe" restore "file://%letter%:\backup\\" --backup-name="Everything but repositories" --dbpath="C:\home\duplicati\duplicati-db.sqlite" --passphrase=PASSPHRASE --disable-module=console-password-input --alternate-destination-marker=my_backup_is_here.txt --alternate-target-paths=*:\backup
   )

) else (
   echo Cancelled.
)

pause