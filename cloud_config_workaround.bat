@echo off
setlocal

:: get Documents folder from registry ( will work even with onedrive )
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal') do set DOCUMENTS=%%b

:: get Appdata folder from registry
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v AppData') do set APPDATA=%%b

:: Documents folder location
set "DOCUMENTS=%USERPROFILE%\Documents"

:: location to keep good local config files
set "GOODCONFIGSDIR=%DOCUMENTS%\game_configs"

:: create a directory to keep good config file
mkdir "%GOODCONFIGSDIR%\%SteamAppId%"

:: get location of config file used in game based on steam appid
if %SteamAppId%==814380 (
            set "GAMECONFIGDIR=%APPDATA%\Sekiro"
            set "GAMECONFIG=GraphicsConfig.xml"
)
if %SteamAppId%==292030 (
            set "GAMECONFIGDIR=%DOCUMENTS%\The Witcher 3"
            set "GAMECONFIG=user.settings"
)
if %SteamAppId%==499450 (
            set "GAMECONFIGDIR=%DOCUMENTS%\The Witcher 3"
            set "GAMECONFIG=user.settings"
)
if %SteamAppId%==32360 (
            set "GAMECONFIGDIR=%APPDATA%\LucasArts\The Secret of Monkey Island Special Edition"
            set "GAMECONFIG=Settings.ini"
)
if %SteamAppId%==1151640 (
            set "GAMECONFIGDIR=%DOCUMENTS%\Horizon Zero Dawn\Saved Game\profile"
            set "GAMECONFIG=graphicsconfig.ini"
)

set "CONFIGPATH=%GAMECONFIGDIR%\%GAMECONFIG%"

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
