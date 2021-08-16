FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

 ARG MEDIA_DRV_VERSION=21.2.3

RUN apt-get update && \
	apt-get -y install --no-install-recommends jq unzip ffmpeg mesa-va-drivers ffmpeg libigdgmm11 && \
	wget -O /tmp/intel-media.tar.gz https://github.com/ich777/media-driver/releases/download/intel-media-${MEDIA_DRV_VERSION}/intel-media-${MEDIA_DRV_VERSION}.tar.gz && \
	cd /tmp && \
	tar -C / -xvf /tmp/intel-media.tar.gz && \
	rm -rf /tmp/intel-media.tar.gz && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR=/owncast
ENV START_PARAMS=""
ENV OWNCAST_V="latest"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="owncast"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]