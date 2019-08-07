#!/bin/bash
CUR_V="$(find -name teeworlds[^extended]*\.tar\.gz | cut -d '-' -f 2)"
LAT_V="$(curl -s https://api.github.com/repos/teeworlds/teeworlds/releases/latest | grep tag_name | cut -d '"' -f4)"

https://api.github.com/repos/OpenRCT2/OpenRCT2/releases
https://github.com/OpenRCT2/OpenRCT2/releases/download/v0.2.2/OpenRCT2-0.2.2-linux-x86_64.tar.gz
OpenRCT2-0.2.0-linux-x86_64.tar.gz

if [ -z "$CUR_V" ]; then
   echo "---OpenRCT2 not found!---"
   cd ${SERVER_DIR}
   curl -s https://api.github.com/repos/OpenRCT2/OpenRCT2/releases/latest \
   | grep "browser_download_url.*teeworlds-[^extended].*-linux_x86_64\.tar\.gz" \
   | cut -d ":" -f 2,3 \
   | cut -d '"' -f2 \
   | wget -qi -
   tar --directory ${SERVER_DIR} -xvzf /serverdata/serverfiles/teeworlds-$LAT_V-linux_x86_64.tar.gz
   mv ${SERVER_DIR}/teeworlds-$LAT_V-linux_x86_64 ${SERVER_DIR}/teeworlds  
elif [ "$LAT_V" != "$CUR_V" ]; then
   echo "---Newer version found, installing!---"
   rm ${SERVER_DIR}/teeworlds-$CUR_V-linux_x86_64.tar.gz
   cd ${SERVER_DIR}
   curl -s https://api.github.com/repos/OpenRCT2/OpenRCT2/releases/latest \
   | grep "browser_download_url.*teeworlds-[^extended].*-linux_x86_64\.tar\.gz" \
   | cut -d ":" -f 2,3 \
   | cut -d '"' -f2 \
   | wget -qi -
   tar --directory ${SERVER_DIR} -xvzf /serverdata/serverfiles/teeworlds-$LAT_V-linux_x86_64.tar.gz
   mv ${SERVER_DIR}/teeworlds-$LAT_V-linux_x86_64 ${SERVER_DIR}/teeworlds
elif [ "$LAT_V" == "$CUR_V" ]; then
   echo "---Teeworlds Version up-to-date---"
else
   echo "---Something went wrong, putting server in sleep mode---"
   sleep infinity
fi

echo "---Preparing Server---"
if [ ! -f ${SERVER_DIR}/teeworlds/autoexec.cfg ]; then
   cd ${SERVER_DIR}/teeworlds
   wget -qi https://raw.githubusercontent.com/ich777/docker-teeworlds-server/master/configs/autoexec.cfg
   wget -qi https://raw.githubusercontent.com/ich777/docker-teeworlds-server/master/configs/ctf.cfg
   wget -qi https://raw.githubusercontent.com/ich777/docker-teeworlds-server/master/configs/dm.cfg
   wget -qi https://raw.githubusercontent.com/ich777/docker-teeworlds-server/master/configs/tdm.cfg
fi
chmod -R 770 ${DATA_DIR}

echo "---Starting Server---"
cd ${SERVER_DIR}/teeworlds
./teeworlds_srv -f ${GAME_CONFIG}
