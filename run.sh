#!/bin/bash

umask 002

SYNCTHING_USER=${SYNCTHING_USER:-syncthing}
SYNCTHING_USERID=${SYNCTHING_USERID:-1000}
SYNCTHING_PASSWORD=${SYNCTHING_PASSWORD:-password}
SYNCTHING_GROUP=${SYNCTHING_GROUP:-users}
SYNCTHING_GROUPID=${SYNCTHING_GROUPID:-100}

getent group ${SYNCTHING_GROUP}
if [ $? -ne 0 ]; then
  groupadd -g ${SYNCTHING_GROUPID} ${SYNCTHING_GROUP}
fi

getent passwd ${SYNCTHING_USER}
if [ $? -ne 0 ]; then
  useradd --gid=${SYNCTHING_GROUP} --groups=users --uid=${SYNCTHING_USERID} ${SYNCTHING_USER}
  echo "$SYNCTHING_USER:$SYNCTHING_PASSWORD" | chpasswd
fi

chown ${SYNCTHING_USER}:${SYNCTHING_GROUP} /syncthing-conf
chmod ug+rwX /syncthing-conf
chown ${SYNCTHING_USER}:${SYNCTHING_GROUP} /Sync
chmod ug+rwX /Sync

CONFIG_FOLDER="/syncthing-conf"
CONFIG_FILE="$CONFIG_FOLDER/config.xml"

if [ ! -f "$CONFIG_FILE" ]; then
    /usr/local/bin/syncthing -generate="$CONFIG_FOLDER"
    xmlstarlet ed -L -u "/configuration/gui/address" -v "0.0.0.0:8384" "$CONFIG_FILE"
fi

exec /sbin/setuser ${SYNCTHING_USER} /usr/local/bin/syncthing --home="$CONFIG_FOLDER"
