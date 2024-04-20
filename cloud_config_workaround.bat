@echo off
setlocal
set "SteamAppId=1687950"

:: get Documents folder from registry ( will work even with onedrive )
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal') do set DOCUMENTS=%%b
:: Reparse the variable
call set "DOCUMENTS=%DOCUMENTS%"

:: get Appdata folder from registry
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v AppData') do set APPDATA=%%b
:: Reparse the variable
call set "APPDATA=%APPDATA%"

:: location to keep good local config files
set "GOODCONFIGSDIR=%DOCUMENTS%\game_configs"

:: create a directory to keep good config file
mkdir "%GOODCONFIGSDIR%\%SteamAppId%"

:: get SteamID3 version by converting 64 Bit SteamID with powershell
for /f "delims=" %%a in ('powershell.exe -command "$result=%STEAMID%-76561197960265728; Write-Output $result"') do set SteamID3=%%a

:: get location of config file from the paths.txt file based on steam appid
for /f "tokens=2 delims=;" %%F in ('findstr %SteamAppId% paths.txt') do set "CONFIGPATH=%%F"

:: get just the config file name
for /f "delims=|" %%F in ("%CONFIGPATH%") do set "GAMECONFIG=%%~nxF"

if defined CONFIGPATH (echo %CONFIGPATH%)
if defined GAMECONFIG (echo %GAMECONFIG%)
pause
exit

:: if this is defined then it's a game in the list so use the workaround
if defined GAMECONFIG (goto workaround)
:: else just run the game
%*
exit

:workaround
:: copy the wanted config file to the location used by game
copy "%GOODCONFIGSDIR%\%SteamAppId%\%GAMECONFIG%" "%CONFIGPATH%"
:: this is %command% (i.e. the game exe) and any parameters from the launch options
%*
:: save any config changes you made in-game for next time
copy "%CONFIGPATH%" "%GOODCONFIGSDIR%\%SteamAppId%\"
exit
