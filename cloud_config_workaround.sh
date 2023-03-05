#!/bin/sh

# location to keep good local config files
GOOD_CONFIGS_PATH="/home/${USER}/Documents/game_configs"
LOGFILE="${GOOD_CONFIGS_PATH}/${SteamAppId}_config_workaround.log"
# user directory in the proton prefix
WIN_USER_PATH="pfx/drive_c/users/steamuser"

# create a directory to keep good config file
mkdir -p "${GOOD_CONFIGS_PATH}/${SteamAppId}"

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
