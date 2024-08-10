@echo off

REM find the drive letter of the repository device and copy the files of the C:\home
for /f %%a in ('wmic logicaldisk where "VolumeName='KEYNAME'" get Caption ^| find ":"') do set letter=%%a

if not defined letter (
   echo Repository device cannot be found
) else (
   REM ensure clone of notepad++ exists
   if exist "c:\home\work\archives\notepad++" (
      echo Clone of notepad++ already exists at c:\home\work\archives\notepad++
   ) else (
      REM clone notepad++, first ensuring that all the required folders exist
      echo Cloning notepad++ from %letter%
      md "c:\home\work\archives\notepad++"
      pushd "c:\home\work\archives\notepad++"
      
      C:\home\static\bin\PortableGit-2.41.0-64-bit\bin\git clone -o usbKey "%letter%\repositories\work\archives\notepad++" .
      C:\home\static\bin\PortableGit-2.41.0-64-bit\bin\git checkout --no-track -b main
      C:\home\static\bin\PortableGit-2.41.0-64-bit\bin\git pull usbKey main
   )
)

pause
