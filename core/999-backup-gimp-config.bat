@echo off

if exist "%USERPROFILE%\AppData\Roaming\GIMP\2.10\" (
   REM first remove the previous backup
   rd /S /Q %~dp0softwares\gimp\2.10\
   
   REM then backup the whole 2.10/ folder
   xcopy /Y /Q /S %USERPROFILE%\AppData\Roaming\GIMP\2.10\ %~dp0softwares\gimp\2.10\
) else (
   echo No folder at %USERPROFILE%\AppData\Roaming\GIMP\2.10\
)

pause