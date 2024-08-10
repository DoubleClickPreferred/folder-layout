@echo off

REM find the drive letter of the repository device and copy the files of the C:\home
for /f %%a in ('wmic logicaldisk where "VolumeName='BACKUP-KEYNAME'" get Caption ^| find ":"') do set letter=%%a

if not defined letter (
   echo Backup drive cannot be found
) else (
   REM backup C:\home\static
   "C:\Program Files\Duplicati 2\Duplicati.CommandLine.exe" backup "file://%letter%:\backup\\" "C:\home\static\\" --backup-name="Everything but repositories" --dbpath="C:\home\duplicati\duplicati-db.sqlite" --encryption-module=aes --compression-module=zip --dblock-size=50mb --keep-versions=7 --passphrase=PASSPHRASE --disable-module=console-password-input --alternate-destination-marker=my_backup_is_here.txt --alternate-target-paths=*:\backup
   
   REM copy the duplicati/ folder on the backup drive to ensure the DB file(s) there are up-to-date
   xcopy /Y /Q C:\home\duplicati\ %letter%\home\duplicati\
)

pause