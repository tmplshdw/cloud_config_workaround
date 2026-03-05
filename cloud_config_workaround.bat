@echo off
setlocal

set "scriptpath=%~dp0"

:: get Documents folder from registry (will work even with OneDrive)
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal') do set DOCUMENTS=%%b
:: Reparse the variable
call set "DOCUMENTS=%DOCUMENTS%"

:: get Appdata folder from registry
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v AppData') do set APPDATA=%%b
:: Reparse the variable
call set "APPDATA=%APPDATA%"

:: get SteamAppId from steam_appid.txt
for /f "tokens=*" %%a in (steam_appid.txt) do set "SteamAppId=%%a"
:: Reparse the variable
call set "SteamAppId=%SteamAppId%"

@echo off
setlocal enabledelayedexpansion

if "%SteamAppId%"=="292030" (
    set "GAMEEXE=witcher3.exe"
    set "GAMEDIR=bin\x64_dx12"

    if exist "launcher-configuration.json" (
        set "FALLBACK_RAW="
        for /f "tokens=2 delims=:" %%A in ('type "launcher-configuration.json" 2^>nul ^| find /i "fallback"') do (
            set "FALLBACK_RAW=%%A"
        )

        if not "!FALLBACK_RAW!"=="" (
            set "FALLBACK=!FALLBACK_RAW:,=!"
            set "FALLBACK=!FALLBACK:"=!"
            for /f "tokens=*" %%B in ("!FALLBACK!") do set "FALLBACK=%%B"
            
            if /i "!FALLBACK!"=="DirectX 11" set "GAMEDIR=bin\x64"
            if /i "!FALLBACK!"=="DirectX 12" set "GAMEDIR=bin\x64_dx12"
        )
    )
)

if "%SteamAppId%"=="499450" (
    set "GAMEEXE=witcher3.exe"
    set "GAMEDIR=bin\x64_dx12"

    if exist "launcher-configuration.json" (
        set "FALLBACK_RAW="
        for /f "tokens=2 delims=:" %%A in ('type "launcher-configuration.json" 2^>nul ^| find /i "fallback"') do (
            set "FALLBACK_RAW=%%A"
        )

        if not "!FALLBACK_RAW!"=="" (
            set "FALLBACK=!FALLBACK_RAW:,=!"
            set "FALLBACK=!FALLBACK:"=!"
            for /f "tokens=*" %%B in ("!FALLBACK!") do set "FALLBACK=%%B"
            
            if /i "!FALLBACK!"=="DirectX 11" set "GAMEDIR=bin\x64"
            if /i "!FALLBACK!"=="DirectX 12" set "GAMEDIR=bin\x64_dx12"
        )
    )
)


:: location to keep good local config files
set "GOODCONFIGSDIR=%DOCUMENTS%\game_configs"

:: create a directory to keep good config file
mkdir "%GOODCONFIGSDIR%\%SteamAppId%"

:: get location of config file from the paths.txt file based on steam appid
for /f "tokens=2 delims=;" %%F in ('findstr %SteamAppId% %scriptpath%paths.txt') do set "CONFIGPATH=%%F"
call set "CONFIGPATH=%CONFIGPATH%"

:: get the config file name
for /f "tokens=3 delims=;" %%F in ('findstr %SteamAppId% %scriptpath%paths.txt') do set "GAMECONFIG=%%F"
call set "GAMECONFIG=%GAMECONFIG%"

:: if this is defined then it's a game in the list so use the workaround
if defined GAMECONFIG (goto workaround)
:: else just run the game
:: %*
:: exit

:workaround
:: copy the wanted config file to the location used by game
copy "%GOODCONFIGSDIR%\%SteamAppId%\%GAMECONFIG%" "%CONFIGPATH%" > "%GOODCONFIGSDIR%\%SteamAppId%_config_workaround.log"

:: Check if we defined a custom exe/dir (like for Witcher 3), otherwise run default
if defined GAMEEXE (
    start /wait "" /d "%GAMEDIR%" "%GAMEEXE%"
) else (
    %*
)

:: save any config changes you made in-game for next time
copy "%CONFIGPATH%\%GAMECONFIG%" "%GOODCONFIGSDIR%\%SteamAppId%" >> "%GOODCONFIGSDIR%\%SteamAppId%_config_workaround.log"

:: exit
