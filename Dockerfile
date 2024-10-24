FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-openrct2-server"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl libfreetype6 fontconfig libzip4 libicu72 && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_VERSION=latest
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
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]