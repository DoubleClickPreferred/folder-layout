@echo off

REM find the drive letter of the repository device and copy the files of the C:\home
for /f %%a in ('wmic logicaldisk where "VolumeName='REPOSITORIES-KEYNAME'" get Caption ^| find ":"') do set letter=%%a

if not defined letter (
   echo Repository drive cannot be found
) else (
   REM ensure clone of core exists
   if exist "C:\home\core" (
      echo Clone of core already exists at C:\home\core
   ) else (
      REM clone core, first ensuring that all the required folders exist
      echo Cloning core from %letter%
      md C:\home\core
      pushd C:\home\core
      
      C:\home\static\bin\PortableGit-2.41.0-64-bit\bin\git clone -b dev %letter%\repositories\core C:\home\core
   )
)

pause
