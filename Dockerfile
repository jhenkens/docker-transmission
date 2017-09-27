FROM lsiobase/alpine:3.6
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
ARG TRANSMISSION_VER=2.92-seq
LABEL build_version="johanhenkens version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install packages
RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && BUILD_DEPS=" \
    build-base \
    patch \
    libtool \
    libevent-dev \
    automake \
    autoconf \
    cmake \
    wget \
    tar \
    xz \
    zlib-dev \
    cppunit-dev \
    libressl-dev \
    ncurses-dev \
    curl-dev \
    binutils" \
 && \
 apk add --no-cache \
    ${BUILD_DEPS} \
	ca-certificates \
	curl \
	jq \
	libressl \
	p7zip \
	gzip \
	zip \
	zlib \
	s6 \
	su-exec \
	libevent \
	rsync \
	tar \
	unrar \
	unzip \
 && cd /tmp && mkdir transmission \
 && cd transmission && wget -qO- https://github.com/Mikayex/transmission/archive/${TRANSMISSION_VER}.tar.gz | tar xz --strip 1 \
 && cd /tmp/transmission \
 && cmake . \
 && make -j ${NB_CORES} && make install \
 && strip -s /usr/local/bin/transmission-daemon \
 && apk del ${BUILD_DEPS} \
 && rm -rf /var/cache/apk/* /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9091 51413
VOLUME /config /downloads /watch
