FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl libjansson4 libzip4 libpng-tools libicu63 libfreetype6 libfontconfig libsdl2-2.0-0 libspeexdsp-dev libduktape203 && \
	cd /usr/lib/x86_64-linux-gnu && \
	ln -s libduktape.so.203 libduktape.so.202 && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_VERSION=0.2.2
ENV GAME_CONFIG="template"
ENV GAME_PORT=11753
ENV GAME_SAVE_NAME="docker.sav"
ENV LOAD_LAST_AUTOSAVE="true"
ENV ADMIN_NAME=""
ENV ADMIN_HASH=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="openrct2"

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
COPY /libicudata.so.60 	/usr/lib/x86_64-linux-gnu/libicudata.so.60
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]