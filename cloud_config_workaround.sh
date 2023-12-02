#!/bin/sh

# location to keep good local config files
GOOD_CONFIGS_PATH="/home/${USER}/Documents/game_configs"
LOGFILE="${GOOD_CONFIGS_PATH}/${SteamAppId}_config_workaround.log"
# user directory in the proton prefix
WIN_USER_PATH="pfx/drive_c/users/steamuser"

# create a directory to keep good config file
mkdir -p "${GOOD_CONFIGS_PATH}/${SteamAppId}"

# horrible kludge to get steamid
STEAMID=$(grep -Pzo '"'${SteamUser}'"\s+{\s+"SteamID"\s+"[0-9]+"' /home/${USER}/.local/share/Steam/config/config.vdf | grep --text -oP '(?<=\s")[0-9]+')

# get SteamID3 version by converting 64 Bit SteamID
SteamID3=$((${STEAMID}-76561197960265728))

# get location of config file used in game based on steam appid
case ${SteamAppId} in
    814380)
        CONFIG_PATH="Application Data/Sekiro"
        CONFIG="GraphicsConfig.xml"
        ;;
    292030 | 499450) # 499450 GOTY edition, not sure if necessary
        CONFIG_PATH="Documents/The Witcher 3"
        CONFIG="user.settings"
        ;;
    32360)
        CONFIG_PATH="Application Data/LucasArts/The Secret of Monkey Island Special Edition"
        CONFIG="Settings.ini"
        ;;
    1151640)
        CONFIG_PATH="Documents/Horizon Zero Dawn/Saved Game/profile"
        CONFIG="graphicsconfig.ini"
        ;;
    1313140)
        CONFIG_PATH="AppData/LocalLow/Massive Monster/Cult Of The Lamb/saves"
        CONFIG="settings.json"
        ;;
    524220)
        CONFIG_PATH="Documents/My Games/NieR_Automata"
        CONFIG="SystemData.dat"
        ;;
    757310)
        CONFIG_PATH="AppData/LocalLow/Shedworks/Sable/SaveData"
        CONFIG="SettingsManager"
        ;;
    1295510)
        CONFIG_PATH="Documents/My Games/DRAGON QUEST XI S/Steam/${SteamID3}/Saved/SaveGames/Book"
        CONFIG="system999.sav"
        ;;
    1687950)
        CONFIG_PATH="Application Data/SEGA/P5R/Steam/${STEAMID}/savedata/SYSTEM"
        CONFIG="SYSTEM.DAT"
        ;;
    1730680)
        CONFIG_PATH="AppData/Local/Bandai Namco Entertainment/KLONOAencore/Saved/SaveGames/${SteamID3}"
        CONFIG="System.bin"
        ;;
    *)
        CONFIG="error"
        ;;
esac

# STEAM_COMPAT_DATA_PATH is set by Steam to be the location for the prefix used by the game
# by default ~/.local/share/Steam/steamapps/compatdata/$SteamAppId
# but may be elsewhere depending on how you set up your steam library storage
GAME_CONFIG_PATH="${STEAM_COMPAT_DATA_PATH}/${WIN_USER_PATH}/${CONFIG_PATH}/${CONFIG}"
echo "game config file: ${GAME_CONFIG_PATH}" >> ${LOGFILE} 2>&1

if [ "${CONFIG}" = "error" ]; then # run the game without workaround
    echo "error" >> ${LOGFILE} 2>&1
    "$@" # filled in with %command% (game executable stuff) and any other launch options
else
    # copy the wanted config file to the location used by game
    cp -v "${GOOD_CONFIGS_PATH}/${SteamAppId}/${CONFIG}" "${GAME_CONFIG_PATH}" >> "${LOGFILE}" 2>&1

    "$@" # filled in with %command% (game executable stuff) and any other launch options

    # save any config changes you made in-game for next time
    cp -v "${GAME_CONFIG_PATH}" "${GOOD_CONFIGS_PATH}/${SteamAppId}/" >> "${LOGFILE}" 2>&1
fi
