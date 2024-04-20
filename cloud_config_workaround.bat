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

:: get SteamID3 version by converting 64 Bit SteamID with powershell
for /f "delims=" %%a in ('powershell.exe -command "$result=%STEAMID%-76561197960265728; Write-Output $result"') do set SteamID3=%%a

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
if %SteamAppId%==1313140 (
            set "GAMECONFIGDIR=%USERPROFILE%\AppData\LocalLow\Massive Monster\Cult Of The Lamb\saves"
            set "GAMECONFIG=settings.json"
)
if %SteamAppId%==524220 (
            set "GAMECONFIGDIR=%DOCUMENTS%\My Games\NieR_Automata"
            set "GAMECONFIG=SystemData.dat"
)
if %SteamAppId%==1113560 (
            set "GAMECONFIGDIR=%DOCUMENTS%\My Games\NieR Replicant ver.1.22474487139\Steam\%STEAMID%"
            set "GAMECONFIG=drawing_settings.ini"
)
if %SteamAppId%==757310 (
            set "GAMECONFIGDIR=%USERPROFILE%\AppData\LocalLow\Shedworks\Sable\SaveData"
            set "GAMECONFIG=SettingsManager"
)
if %SteamAppId%==1295510 (
            set "GAMECONFIGDIR=%DOCUMENTS%\My Games\DRAGON QUEST XI S\Steam\%SteamID3%\Saved\SaveGames\Book"
            set "GAMECONFIG=system999.sav"
)
if %SteamAppId%==1687950 (
            set "GAMECONFIGDIR=%APPDATA%\SEGA\P5R\Steam\%STEAMID%\savedata\SYSTEM"
            set "GAMECONFIG=SYSTEM.DAT"
)
if %SteamAppId%==1730680 (
            set "GAMECONFIGDIR=%LOCALAPPDATA%\Bandai Namco Entertainment/KLONOAencore\Saved\SaveGames\%SteamID3%"
            set "GAMECONFIG=System.bin"
)
if %SteamAppId%==990080 (
            set "GAMECONFIGDIR=%USERPROFILE%\AppData\Local\Hogwarts Legacy\Saved\SaveGames\%SteamID3%"
            set "GAMECONFIG=SavedUserOptions.sav"
)
if %SteamAppId%==1608070 (
            set "GAMECONFIGDIR=%DOCUMENTS%\My Games\CRISIS CORE FINAL FANTASY VII REUNION\Steam\%STEAMID%"
            set "GAMECONFIG=SAVEDATA_SYSTEM.sav"
)
if %SteamAppId%==1850570 (
            set "GAMECONFIGDIR=%LOCALAPPDATA%\KojimaProductions\DeathStrandingDC\%SteamID3%\profile"
            set "GAMECONFIG=game_settings.cfg"
)
if %SteamAppId%==1190460 (
            set "GAMECONFIGDIR=%LOCALAPPDATA%\KojimaProductions\DeathStranding\%SteamID3%\profile"
            set "GAMECONFIG=game_settings.cfg"
)
if %SteamAppId%==2337640 (
            set "GAMECONFIGDIR=%USERPROFILE%\AppData\Local\PinballM\Saved\SaveGames\%STEAMID%"
            set "GAMECONFIG=settings.sav"
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
