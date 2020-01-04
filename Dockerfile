FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl libjansson4 libzip4 libpng-tools libicu63 libfreetype6 libfontconfig libsdl2-2.0-0 libspeexdsp-dev && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_VERSION=0.2.2
ENV GAME_CONFIG="template"
ENV GAME_PORT=11753
ENV GAME_SAVE_NAME="docker.sav"
ENV ADMIN_NAME=""
ENV ADMIN_HASH=""
ENV UMASK=000
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID openrct2 && \
	chown -R openrct2 $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R openrct2 /opt/scripts

USER openrct2

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]