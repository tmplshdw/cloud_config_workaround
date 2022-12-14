@echo off
setlocal
echo Cloud Config Workaround

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
if exist "%GOODCONFIGSDIR%\%SteamAppId%\" (
    echo Using %GOODCONFIGSDIR%\%SteamAppId%\ directory
) else (
mkdir "%GOODCONFIGSDIR%\%SteamAppId%"
)

set "GAMEEXE="""

:: get location of config file used in game based on steam appid
if %SteamAppId%==814380 (
            set "GAMECONFIGDIR=%APPDATA%\Sekiro"
            set "GAMECONFIG=GraphicsConfig.xml"
            set "GAMEEXE="""
)
if %SteamAppId%==292030 (
            set "GAMECONFIGDIR=%DOCUMENTS%\The Witcher 3"
            set "GAMECONFIG=user.settings"
            set "GAMEEXE=witcher3.exe"
)
if %SteamAppId%==499450 (
            set "GAMECONFIGDIR=%DOCUMENTS%\The Witcher 3"
            set "GAMECONFIG=user.settings"
            set "GAMEEXE=witcher3.exe"
)
if %SteamAppId%==32360 (
            set "GAMECONFIGDIR=%APPDATA%\LucasArts\The Secret of Monkey Island Special Edition"
            set "GAMECONFIG=Settings.ini"
            set "GAMEEXE="""
)
if %SteamAppId%==1151640 (
            set "GAMECONFIGDIR=%DOCUMENTS%\Horizon Zero Dawn\Saved Game\profile"
            set "GAMECONFIG=graphicsconfig.ini"
            set "GAMEEXE="""
)

set "CONFIGPATH=%GAMECONFIGDIR%\%GAMECONFIG%"

:: if this is defined then it's a game in the list so use the workaround
if defined GAMECONFIG (goto workaround)
:: else just run the game
%*
exit

:waitprocesstostart
echo Waiting for %GAMEEXE% to start
:loopwaitprocesstostart
:: wait for game to start ( usefull if the game has a launcher )
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %GAMEEXE%"') DO IF %%x == %GAMEEXE% goto waitprocesstoend
TIMEOUT /T 3 /nobreak >nul
goto loopwaitprocesstostart

:waitprocesstoend
echo Waiting for %GAMEEXE% to end
:loopwaitprocesstoend
:: wait for game to end
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %GAMEEXE%"') DO IF %%x NEQ %GAMEEXE% goto saveconfig
TIMEOUT /T 3 /nobreak >nul
goto loopwaitprocesstoend

:workaround
echo Applying Workaround
:: copy the wanted config file to the location used by game
copy "%GOODCONFIGSDIR%\%SteamAppId%\%GAMECONFIG%" "%CONFIGPATH%"
:: this is %command% (i.e. the game exe) and any parameters from the launch options
%*
IF %GAMEEXE% == "" (goto saveconfig)
goto waitprocesstostart

:saveconfig
echo Saving Configs
:: save any config changes you made in-game for next time
copy "%CONFIGPATH%" "%GOODCONFIGSDIR%\%SteamAppId%\"
exit
