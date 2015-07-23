FROM phusion/baseimage:0.9.16
MAINTAINER thomfab
# inspired by :
#    https://registry.hub.docker.com/u/istepanov/syncthing/dockerfile/
#    https://registry.hub.docker.com/u/tianon/syncthing/

ENV DEBIAN_FRONTEND noninteractive

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

RUN apt-get update -qq \
    && apt-get install -qq --force-yes xmlstarlet \
    && apt-get install -y ca-certificates --no-install-recommends \
    && apt-get install -y curl --no-install-recommends \
    && apt-get autoremove \
    && apt-get autoclean

# gpg: key 00654A3E: public key "Syncthing Release Management <release@syncthing.net>" imported
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 37C84554E7E0A261E4F76E1ED26E6ED000654A3E

ENV SYNCTHING_VERSION 0.11.16

RUN set -x \
        && tarball="syncthing-linux-amd64-v${SYNCTHING_VERSION}.tar.gz" \
        && curl -SL "https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/"{"$tarball",sha1sum.txt.asc} -O \
        && apt-get purge -y --auto-remove curl \
        && gpg --verify sha1sum.txt.asc \
        && grep -E " ${tarball}\$" sha1sum.txt.asc | sha1sum -c - \
        && rm sha1sum.txt.asc \
        && tar -xvf "$tarball" --strip-components=1 "$(basename "$tarball" .tar.gz)"/syncthing \
        && mv syncthing /usr/local/bin/syncthing \
        && rm "$tarball"

ADD run.sh /run.sh
RUN chmod +x /run.sh

RUN mkdir /syncthing-conf && \
    mkdir /Sync

VOLUME ["/syncthing-conf", "/Sync"]

EXPOSE 8384 22000 21025/udp 21026/udp 22026/udp

CMD ["/run.sh"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
