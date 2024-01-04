#!/bin/bash
CUR_V="$(find ${SERVER_DIR} -name openrct2installedv* | cut -d 'v' -f4-)"
LAT_V="$(curl -sL https://api.github.com/repos/OpenRCT2/OpenRCT2/releases/latest | grep tag_name | cut -d '"' -f4 | cut -d 'v' -f2)"
MANUAL="$(find ${SERVER_DIR} -name OpenRCT*-linux-x86_64.AppImage | sort -V | tail -1 | cut -d '/' -f4)"
MAN_V="$(find ${SERVER_DIR} -name OpenRCT*-linux-x86_64.AppImage | sort -V | tail -1 | cut -d '-' -f2- | sed 's/-linux-x86_64.AppImage//g')"
if [ "${GAME_VERSION}" == "latest" ]; then
	GAME_VERSION=$LAT_V
fi

rm -rf ${SERVER_DIR}/data ${SERVER_DIR}/doc ${SERVER_DIR}/libicuuc.so.60 ${SERVER_DIR}/libopenrct2.so ${SERVER_DIR}/openrct2 ${SERVER_DIR}/openrct2-cli ${SERVER_DIR}/openrct2-cli

if [ ! -z $MANUAL ]; then
  echo "---Manual placed OpenRCT2 AppImage found, installing---"
  if [ -d ${SERVER_DIR}/ORCT2 ]; then
    rm -rf ${SERVER_DIR}/ORCT2
  fi
  cd ${SERVER_DIR}
  chmod +x ${SERVER_DIR}/${MANUAL}
  ${SERVER_DIR}/${MANUAL} --appimage-extract
  mv ${SERVER_DIR}/squashfs-root ${SERVER_DIR}/ORCT2
  rm ${SERVER_DIR}/$MANUAL
  touch ${SERVER_DIR}/openrct2installedv$MAN_V
  CUR_V="$(find ${SERVER_DIR} -name openrct2installedv* | cut -d 'v' -f4-)"
  sleep 2
  if [ "$LAT_V" != "$MAN_V" ]; then
    echo "-----------------------------------------"
    echo "---Newer version of OpenRCT2 available---"
    echo "---Installed version: $MAN_V ------------"
    echo "---Available version: $LAT_V ------------"
    echo "-----------------------------------------"
    sleep 5
  fi
else
  if [ -z "$CUR_V" ]; then
    echo "---OpenRCT2 not found, downloading!---"
    cd ${SERVER_DIR}
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/OPENRCT2-v$LAT_V.AppImage https://github.com/OpenRCT2/OpenRCT2/releases/download/v${LAT_V}/OpenRCT2-${LAT_V}-linux-x86_64.AppImage ; then
      echo "---Sucessfully downloaded OpenRCT2---"
    else
      echo "---Something went wrong, can't download OpenRCT2, putting container in sleep mode---"
      rm -f ${SERVER_DIR}/OPENRCT2-v$LAT_V.AppImage
      sleep infinity
    fi
    chmod +x ${SERVER_DIR}/OPENRCT2-v$LAT_V.AppImage
    ${SERVER_DIR}/OPENRCT2-v$LAT_V.AppImage --appimage-extract
    mv ${SERVER_DIR}/squashfs-root ${SERVER_DIR}/ORCT2
    rm -f ${SERVER_DIR}/OPENRCT2-v$LAT_V.AppImage
    touch ${SERVER_DIR}/openrct2installedv${GAME_VERSION}
    CUR_V="$(find ${SERVER_DIR} -name openrct2installedv* | cut -d 'v' -f4-)"
    sleep 2
    if [ "$LAT_V" != "$CUR_V" ]; then
      echo "-----------------------------------------"
      echo "---Newer version of OpenRCT2 available---"
      echo "---Installed version: $CUR_V ------------"
      echo "---Available version: $LAT_V ------------"
      echo "-----------------------------------------"
      sleep 5
    fi
  elif [ "${GAME_VERSION}" != "$CUR_V" ]; then
    echo "---Version missmatch, installing v${GAME_VERSION}!---"
    rm -f ${SERVER_DIR}/openrct2installedv$GAME_VERSION
    cd ${SERVER_DIR}
    rm -rf ${SERVER_DIR}/ORCT2
    if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/OPENRCT2-v$GAME_VERSION.AppImage https://github.com/OpenRCT2/OpenRCT2/releases/download/v${GAME_VERSION}/OpenRCT2-${GAME_VERSION}-linux-x86_64.AppImage ; then
      echo "---Sucessfully downloaded OpenRCT2---"
    else
      echo "---Something went wrong, can't download OpenRCT2, putting container in sleep mode---"
      rm -f ${SERVER_DIR}/OPENRCT2-v$GAME_VERSION.AppImage
      sleep infinity
    fi
    ${SERVER_DIR}/OPENRCT2-v$LAT_V.AppImage
    ${SERVER_DIR}/OPENRCT2-v$GAME_VERSION.AppImage --appimage-extract
    mv ${SERVER_DIR}/squashfs-root ${SERVER_DIR}/ORCT2
    rm -f ${SERVER_DIR}/OPENRCT2-v$LAT_V.AppImage
    touch ${SERVER_DIR}/openrct2installedv${GAME_VERSION}
    CUR_V="$(find ${SERVER_DIR} -name openrct2installedv* | cut -d 'v' -f4-)"
    sleep 2
    if [ "$LAT_V" != "$CUR_V" ]; then
      echo "-----------------------------------------"
      echo "---Newer version of OpenRCT2 available---"
      echo "---Installed version: $CUR_V ------------"
      echo "---Available version: $LAT_V ------------"
      echo "-----------------------------------------"
      sleep 5
      fi
  elif [ "${GAME_VERSION}" == "$CUR_V" ]; then
    echo "---OpenRCT2 version matches installed version---"
    if [ "$LAT_V" != "$CUR_V" ]; then
      echo "-----------------------------------------"
      echo "---Newer version of OpenRCT2 available---"
      echo "---Installed version: $CUR_V ------------"
      echo "---Available version: $LAT_V ------------"
      echo "-----------------------------------------"
      sleep 5
    fi
  else
    echo "---Something went wrong, putting server in sleep mode---"
    sleep infinity
  fi
fi

echo "---Preparing Server---"
if [ ! -d ${SERVER_DIR}/saves ]; then
  mkdir ${SERVER_DIR}/saves
fi
if [ ! -d ${SERVER_DIR}/user-data ]; then
  mkdir ${SERVER_DIR}/user-data
fi
SAVE_PRES="$(find ${SERVER_DIR}/saves -name *.sv6* | cut -d '/' -f5)"
if [ -z "$SAVE_PRES" ]; then
  echo "---No savegame found, downloading---"
  cd ${SERVER_DIR}/saves
  if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-openrct2-server/master/saves/docker.sv6 ; then
    echo "---Successfully downloaded savegame---"
  else
    echo "---Can't download savegame putting server into sleep mode---"
    sleep infinity
  fi
fi
if [ ! -f ${SERVER_DIR}/user-data/groups.json ]; then
  echo "---No 'groups.json' found, downloading---"
  cd ${SERVER_DIR}/user-data/
  if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-openrct2-server/master/config/groups.json ; then
    echo "---Successfully downloaded 'groups.json'---"
  else
    echo "---Can't download 'groups.json' putting server into sleep mode---"
    sleep infinity
  fi
fi
if [ ! -f ${SERVER_DIR}/user-data/config.ini ]; then
  echo "---No config.ini found, downloading---"
  cd ${SERVER_DIR}/user-data/
  if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-openrct2-server/master/config/config.ini ; then
    echo "---Successfully downloaded 'config.ini'---"
  else
    echo "---Can't download 'config.ini' putting server into sleep mode---"
    sleep infinity
  fi
fi
echo "---Setting up config.ini---"
if grep -rq 'player_name = "template_player_name"' ${SERVER_DIR}/user-data/config.ini; then
  sed -i '/player_name = "template_player_name"/c\player_name = "server"' ${SERVER_DIR}/user-data/config.ini
fi
if grep -rq 'server_name = "template_server_name"' ${SERVER_DIR}/user-data/config.ini; then
  sed -i '/server_name = "template_server_name"/c\server_name = "DockerServer v'"${GAME_VERSION}"'"' ${SERVER_DIR}/user-data/config.ini
fi
if grep -rq 'server_name = "DockerServer v' ${SERVER_DIR}/user-data/config.ini; then
  sed -i '/server_name = "DockerServer v/c\server_name = "DockerServer v'"${GAME_VERSION}"'"' ${SERVER_DIR}/user-data/config.ini
fi
if grep -rq 'server_description = "template_server_description"' ${SERVER_DIR}/user-data/config.ini; then
  sed -i '/server_description = "template_server_description"/c\server_description = "This is a basic OpenRCT2 v'"${GAME_VERSION}"' server running in a Docker container mainly created and optimized for Unraid"' ${SERVER_DIR}/user-data/config.ini
fi
if grep -rq 'This is a basic OpenRCT2 v' ${SERVER_DIR}/user-data/config.ini; then
  sed -i '/This is a basic OpenRCT2 v/c\server_description = "This is a basic OpenRCT2 v'"${GAME_VERSION}"' server running in a Docker container mainly created and optimized for Unraid"' ${SERVER_DIR}/user-data/config.ini
fi
if grep -rq 'server_greeting = "template_server_description"' ${SERVER_DIR}/user-data/config.ini; then
  sed -i '/server_greeting = "template_server_description"/c\server_greeting = "Welcome to OpenRCT2 v'"${GAME_VERSION}"'"' ${SERVER_DIR}/user-data/config.ini
fi
if grep -rq 'Welcome to OpenRCT2 v' ${SERVER_DIR}/user-data/config.ini; then
  sed -i '/Welcome to OpenRCT2 v/c\server_greeting = "Welcome to OpenRCT2 v'"${GAME_VERSION}"'"' ${SERVER_DIR}/user-data/config.ini
fi
if grep -rq 'pause_server_if_no_clients = template_pause_server' ${SERVER_DIR}/user-data/config.ini; then
  sed -i '/pause_server_if_no_clients = template_pause_server/c\pause_server_if_no_clients = true' ${SERVER_DIR}/user-data/config.ini
fi
if [ ! -f ${SERVER_DIR}/user-data/users.json ]; then
  echo "---No users.json found, downloading---"
  cd ${SERVER_DIR}/user-data/
  if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-openrct2-server/master/config/users.json ; then
    echo "---Successfully downloaded 'user.json'---"
  else
    echo "---Can't download 'user.json' putting server into sleep mode---"
    sleep infinity
  fi
fi
if [ "${ADMIN_HASH}" != "" ]; then
  if grep -rq '"hash": "template_hash",' ${SERVER_DIR}/user-data/users.json; then
    sed -i '/"hash": "template_hash",/c\\t\t"hash": "'"${ADMIN_HASH}"'",' ${SERVER_DIR}/user-data/users.json
  fi
fi
if [ "${ADMIN_NAME}" != "" ]; then
  if grep -rq '"name": "template_name",' ${SERVER_DIR}/user-data/users.json; then
    sed -i '/"name": "template_name",/c\\t\t"name": "'"${ADMIN_NAME}"'",' ${SERVER_DIR}/user-data/users.json
  fi
fi

chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Starting Server---"
export LD_LIBRARY_PATH=${SERVER_DIR}/ORCT2/usr/lib
cd ${SERVER_DIR}
if [ "${LOAD_LAST_AUTOSAVE}" == "true" ]; then
  if [ -d ${SERVER_DIR}/user-data/save/autosave ]; then
    echo "---Loading last autosave file---"
    ${SERVER_DIR}/ORCT2/usr/bin/openrct2-cli host ${SERVER_DIR}/user-data/save/autosave/"$(ls -l ${SERVER_DIR}/user-data/save/autosave/ | awk '{print $9}' | sort | tail -1)" --user-data-path=${SERVER_DIR}/user-data --port ${GAME_PORT} ${GAME_CONFIG}
  else
    echo "---No autosave found, loading save game: ${GAME_SAVE_NAME}---"
    ${SERVER_DIR}/ORCT2/usr/bin/openrct2-cli host ${SERVER_DIR}/saves/${GAME_SAVE_NAME} --user-data-path=${SERVER_DIR}/user-data --port ${GAME_PORT} ${GAME_CONFIG}
  fi
else
  ${SERVER_DIR}/ORCT2/usr/bin/openrct2-cli host ${SERVER_DIR}/saves/${GAME_SAVE_NAME} --user-data-path=${SERVER_DIR}/user-data --port ${GAME_PORT} ${GAME_CONFIG}
fi