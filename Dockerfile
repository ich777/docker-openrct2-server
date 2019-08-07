FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN apt-get -y install curl wget

ENV DATA_DIR="/serverdata"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_CONFIG="template"
ENV GAME_PORT=8303
ENV UID=99
ENV GID=100

RUN mkdir $DATA_DIR
RUN mkdir $SERVER_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID teeworlds
RUN chown -R teeworlds $DATA_DIR

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R teeworlds /opt/scripts

USER teeworlds

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]