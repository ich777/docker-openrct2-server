#!/bin/bash
CUR_V="$(find ${SERVER_DIR} -name openrct2installedv* | cut -d 'v' -f4)"
LAT_V="$(curl -s https://api.github.com/repos/OpenRCT2/OpenRCT2/releases/latest | grep tag_name | cut -d '"' -f4 | cut -d 'v' -f2)"

echo "---sleep zZz---"
sleep infinity

if [ -z "$CUR_V" ]; then
   echo "---OpenRCT2 not found!---"
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
elif [ "${GAME_V}" != "$CUR_V" ]; then
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

echo "---Preparing Server---"
if [ ! -d ${SERVER_DIR}/saves ]; then
	mkdir ${SERVER_DIR}/saves
fi
SAVE_PRES="$(find ${SERVER_DIR}/saves -name *.sv6 | cut -d '.' -f5)"
if [ -z "$SAVE_PRES" ]; then
	echo "---No Savegame found, downloading---"
    cd ${SERVER_DIR}/saves
    wget -qi - https://raw.githubusercontent.com/ich777/docker-openrct2-server/master/saves/docker.sv6
fi
chmod -R 770 ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/openrct2-cli host ${SERVER_DIR}/saves/${GAME_SAVE_NAME} --port ${GAME_PORT} ${GAME_CONFIG}