@echo off

fd --version

echo:

for /f %%i in ('fzf --version') do set FZF_VERSION=%%i
echo fzf %FZF_VERSION%

echo:

git --version

echo:

rem -- As Java outputs several lines when asked its version, we capture the first one with this convoluted code:
setlocal ENABLEDELAYEDEXPANSION
set count=1
for /F "tokens=* USEBACKQ" %%i in (`java --version`) do (
  set var!count!=%%i
  set /a count=!count!+1
)
echo %var1%
endlocal

echo:

for /f %%i in ('haxe --version') do set HAXE_VERSION=%%i
echo haxe %HAXE_VERSION%

echo:

for /f %%i in ('hl --version') do set HASHLINK_VERSION=%%i
echo HashLink %HASHLINK_VERSION%

echo:

lua -v

echo:

rem -- As Maven outputs several lines when asked its version, we capture the first one with this convoluted code:
setlocal ENABLEDELAYEDEXPANSION
set count=1
for /F "tokens=* USEBACKQ" %%i in (`mvn -v`) do (
  set var!count!=%%i
  set /a count=!count!+1
)
echo %var1%
endlocal

echo:

for /f %%i in ('node -v') do set NODEJS_VERSION=%%i
echo nodeJS %NODEJS_VERSION%

echo:

rem -- As RipGrep outputs several lines when asked its version, we capture the first one with this convoluted code:
setlocal ENABLEDELAYEDEXPANSION
set count=1
for /F "tokens=* USEBACKQ" %%i in (`rg --version`) do (
  set var!count!=%%i
  set /a count=!count!+1
)
echo %var1%
endlocal

echo:

rem -- As Bash outputs several lines when asked its version, we capture the first one with this convoluted code:
setlocal ENABLEDELAYEDEXPANSION
set count=1
rem -- The sh.exe of BusyBox prints its help on the error output but the 'for' loop captures the data on the standard output. We perform a redirect with '2>&1' and needs to escape the characters '>' and '&' thanks to the caret character.
for /F "tokens=* USEBACKQ" %%i in (`sh --help 2^>^&1`) do (
  set var!count!=%%i
  set /a count=!count!+1
)
echo w64devkit %var1%
endlocal

echo:

wasm-opt --version

echo:

pause

