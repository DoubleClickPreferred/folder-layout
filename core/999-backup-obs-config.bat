@echo off

if exist "C:\home\static\bin\OBS-Studio-30.2.2-Windows\config\obs-studio\basic" (
   REM first remove the previous backup
   rd /S /Q %~dp0softwares\obs\
   
   REM then backup the basic/ folder and the global.ini file
   xcopy /Y /Q /S C:\home\static\bin\OBS-Studio-30.2.2-Windows\config\obs-studio\basic\ %~dp0softwares\obs\basic\
   copy /Y /B C:\home\static\bin\OBS-Studio-30.2.2-Windows\config\obs-studio\global.ini %~dp0softwares\obs\global.ini
) else (
   echo No folder at C:\home\static\bin\OBS-Studio-30.2.2-Windows\config\obs-studio\basic
)

pause