#!/bin/bash
CUR_V="$(find ${SERVER_DIR} -name openrct2installedv* | cut -d 'v' -f4-)"
LAT_V="$(curl -s https://api.github.com/repos/OpenRCT2/OpenRCT2/releases/latest | grep tag_name | cut -d '"' -f4 | cut -d 'v' -f2)"
MANUAL="$(find ${SERVER_DIR} -name OpenRCT*-linux-x86_64.tar.gz | cut -d '/' -f4)"
MAN_V="$(find ${SERVER_DIR} -name OpenRCT*-linux-x86_64.tar.gz | cut -d '-' -f2- | sed 's/-linux-x86_64.tar.gz//g')"
if [ "${GAME_VERSION}" == "latest" ]; then
	GAME_VERSION=$LAT_V
fi
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

if [ ! -z $MANUAL ]; then
	echo "---Manual placed OpenRCT2 file found, installing---"
    tar --directory ${SERVER_DIR} -xvzf /serverdata/serverfiles/$MANUAL
    cd ${SERVER_DIR}/OpenRCT2
    cp -R -f ${SERVER_DIR}/OpenRCT2/* ${SERVER_DIR}
    cd ${SERVER_DIR}
    rm ${SERVER_DIR}/$MANUAL
    rm -R ${SERVER_DIR}/OpenRCT2
    touch ${SERVER_DIR}/openrct2installedv$MAN_V
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
     curl -s https://api.github.com/repos/OpenRCT2/OpenRCT2/releases \
     | grep "browser_download_url.*OpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz" \
     | cut -d ":" -f 2,3 \
     | cut -d '"' -f2 \
     | wget -qi -
      if [ ! -s ${SERVER_DIR}/OpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz ]; then
          echo "---You've probably entered a wrong version number the server tar.gz is empty---"
          rm OpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz
          sleep infinity
      fi
     tar --directory ${SERVER_DIR} -xvzf /serverdata/serverfiles/OpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz
     cd OpenRCT2
     cp -R -f ${SERVER_DIR}/OpenRCT2/* ${SERVER_DIR}
     cd ${SERVER_DIR}
     rm ${SERVER_DIR}/OpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz
     rm -R ${SERVER_DIR}/OpenRCT2
     touch ${SERVER_DIR}/openrct2installedv${GAME_VERSION}
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
     rm ${SERVER_DIR}/openrct2installedv$CUR_V
     cd ${SERVER_DIR}
     curl -s https://api.github.com/repos/OpenRCT2/OpenRCT2/releases \
     | grep "browser_download_url.*OpenRCT2-${GAME_VERSION}-linux-x86_64\.tar\.gz" \
     | cut -d ":" -f 2,3 \
     | cut -d '"' -f2 \
     | wget -qi -
      if [ ! -s ${SERVER_DIR}/OpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz ]; then
          echo "---You've probably entered a wrong version number the server tar.gz is empty---"
          rm OpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz
          sleep infinity
      fi
     tar --directory ${SERVER_DIR} -xvzf /serverdata/serverfilesOpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz
     cd OpenRCT2
     cp -R -f ${SERVER_DIR}/OpenRCT2/* ${SERVER_DIR}
     cd ${SERVER_DIR}
     rm ${SERVER_DIR}/OpenRCT2-${GAME_VERSION}-linux-x86_64.tar.gz
     rm -R ${SERVER_DIR}/OpenRCT2
     touch ${SERVER_DIR}/openrct2installedv${GAME_VERSION}
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

echo "---Applying patch for Debian Buster---"
if [ ! -f ${SERVER_DIR}/libicuuc.so.60 ]; then
	cd ${SERVER_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-openrct2-server/master/libicuuc.so.60 ; then
    	echo "---Successfully downloaded patch---"
	else
    	echo "---Can't download patch putting server into sleep mode---"
        sleep infinity
	fi
fi
chmod -R 777 ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/openrct2-cli host ${SERVER_DIR}/saves/${GAME_SAVE_NAME} --user-data-path=${SERVER_DIR}/user-data --port ${GAME_PORT} ${GAME_CONFIG}