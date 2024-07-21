#!/bin/sh

# location to keep good local config files
GOOD_CONFIGS_PATH="/home/${USER}/Documents/game_configs"
# location of paths.txt file containing the config paths for games, default in script directory
PATHS_FILE="$(dirname $(readlink -f $0))/paths.txt"
LOGFILE="${GOOD_CONFIGS_PATH}/${SteamAppId}_config_workaround.log"
# user directory in the proton prefix
WIN_USER_PATH="pfx/drive_c/users/steamuser"

# create a directory to keep good config file
mkdir -p "${GOOD_CONFIGS_PATH}/${SteamAppId}"

# horrible kludge to get steamid
STEAMID=$(grep -Pzo '"'${SteamUser}'"\s+{\s+"SteamID"\s+"[0-9]+"' /home/${USER}/.local/share/Steam/config/config.vdf | grep --text -oP '(?<=\s")[0-9]+')

# get SteamID3 version by converting 64 Bit SteamID
SteamID3=$((${STEAMID}-76561197960265728))

# get the path of config from the paths.txt file
CONFIG_PATH=$(grep ${SteamAppId} ${PATHS_FILE} | cut --delimiter=';' --fields=2 -)
CONFIG=$(grep ${SteamAppId} ${PATHS_FILE} | cut --delimiter=';' --fields=3 -)

# replace Windows path variables with their equivalent for Proton prefix
CONFIG_PATH=$(echo ${CONFIG_PATH} | sed \
    -e "s/%APPDATA%/Application Data/"\
    -e "s/%DOCUMENTS%/Documents/"\
    -e "s/%USERPROFILE%//"\
    -e "s/%LOCALAPPDATA%/AppData\/Local/"\
    -e "s/%STEAMID%/${STEAMID}/"\
    -e "s/%SteamID3%/${SteamID3}/"\
)

# STEAM_COMPAT_DATA_PATH is set by Steam to be the location for the prefix used by the game
# by default ~/.local/share/Steam/steamapps/compatdata/$SteamAppId
# but may be elsewhere depending on how you set up your steam library storage
GAME_CONFIG_PATH="${STEAM_COMPAT_DATA_PATH}/${WIN_USER_PATH}/${CONFIG_PATH}"

if [ -z ${CONFIG} ]; then # run the game without workaround
    echo "error" >> ${LOGFILE} 2>&1
    "$@" # filled in with %command% (game executable stuff) and any other launch options
else
    # copy the wanted config file to the location used by game
    cp -v "${GOOD_CONFIGS_PATH}/${SteamAppId}/${CONFIG}" "${GAME_CONFIG_PATH}" >> "${LOGFILE}" 2>&1

    "$@" # filled in with %command% (game executable stuff) and any other launch options

    # save any config changes you made in-game for next time
    cp -v "${GAME_CONFIG_PATH}/${CONFIG}" "${GOOD_CONFIGS_PATH}/${SteamAppId}/" >> "${LOGFILE}" 2>&1
fi
