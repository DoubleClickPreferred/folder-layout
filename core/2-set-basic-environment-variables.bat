@echo off

rem -------------------------------------------------------------
rem Assumptions of this script:
rem 1. it is located in the core/ folder
rem 2. the core/ and the static/ folders are siblings
rem 3. the static/ folder has a bin/ folder
rem 4. the bin/ folder have a copy of Lua in lua-5.2.3_Win64_bin
rem 5. the bin/ folder have a copy of jdk-20.0.1_windows-x64_bin
rem -------------------------------------------------------------



rem 1. Prepare the use of Git
rem    The GIT_CONFIG_GLOBAL variable points explicitly to the global configuration to use.
rem    As such, git will not read the usual files at $HOME/.gitconfig and $XDG_CONFIG_HOME/.gitconfig and
rem    that's what I want.
rem    The GIT_CONFIG_NOSYSTEM flag ensures that no system-wide git configuration is taken into account.
rem    Read more at: https://git-scm.com/docs/git
rem    And at: https://git-scm.com/docs/git-config#FILES
rem --------------------------------------------------------------------------
setx GIT_CONFIG_GLOBAL %~dp0.gitconfig
setx GIT_CONFIG_NOSYSTEM true
echo GIT_CONFIG_GLOBAL and GIT_CONFIG_NOSYSTEM are set
echo.
echo.




rem 2. Prepare the use of WezTerm
rem    The WEZTERM_CONFIG_FILE variable is picked up by WezTerm
rem    The referenced file is the entry point of the configuration of WezTerm.
rem --------------------------------------------------------------------------
setx WEZTERM_CONFIG_FILE %~dp0wezterm\wezterm.lua
echo WEZTERM_CONFIG_FILE is set
echo.
echo.



rem 3. Prepare the PATH variable
rem    We want to pass the BIN_ABSOLUTE_FOLDER fully resolved (i.e. no more '..' in the pathname).
rem ----------------------------------------------------------------------------------------------
set BIN_ABSOLUTE_FOLDER=
set TO_BIN_FOLDER=..\static\bin\

rem -- Change the current directory to the static/bin/ folder
pushd %TO_BIN_FOLDER%

rem -- Now the CD variable (= current directory) holds the resolved absolute path to the bin/ folder
set BIN_ABSOLUTE_FOLDER=%CD%

rem -- Revert CD to its previous value
popd

%BIN_ABSOLUTE_FOLDER%\lua-5.2.3_Win64_bin\lua -linitialize 2-set-basic-environment-variables.lua %BIN_ABSOLUTE_FOLDER%
echo user-specific PATH is set
echo.
echo.



rem 4. Prepare the JAVA_HOME variable
rem ----------------------------------------------------------------------------------------------


setx JAVA_HOME %BIN_ABSOLUTE_FOLDER%\jdk-20.0.1_windows-x64_bin
echo JAVA_HOME is set
echo.
echo.


pause