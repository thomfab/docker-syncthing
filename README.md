syncthing
=========

Docker container to run syncthing

## Basic usage

Launch the container via docker:
```
docker run -d --name syncthing \
              -p 8384:8384 -p 22000:22000 \
              -p 21025:21025/udp -p 21026:21026/udp -p 22026:22026/udp \
              thomfab/docker-syncthing
```

The admin interface is located at : http://<docker-host>:8384/


## Advanced

Some variables can be customized :

### VOLUME
Two volumes are exposed:
* the root sync folder (/Sync): you can map it to a local folder. Choose wisely as you can only share sub folders that are in the mapped folder.
* the syncthing configuration folder (/syncthing-conf): you can map it to easily access configuration files

Example :
```
docker run -d --name syncthing \
              -p 8384:8384 -p 22000:22000 \
              -p 21025:21025/udp -p 21026:21026/udp -p 22026:22026/udp \
              -v /path/to/syncthing/data:/Sync \
              -v /path/to/syncthing/conf:/syncthing-conf \
              thomfab/docker-syncthing
```

### USER
By default the user "syncthing" (with id 1000) is used. You can customize and pass a user (and its id) of the docker host (so that file ownership is correct).
Example, if your docker host has a user "myuser" with id 1005 you can use :
```
docker run -d --name syncthing \
              -p 8384:8384 -p 22000:22000 \
              -p 21025:21025/udp -p 21026:21026/udp -p 22026:22026/udp \
              -v /path/to/syncthing/data:/Sync \
              -v /path/to/syncthing/conf:/syncthing-conf \
              -e SYNCTHING_USER=myuser -e SYNCTHING_USERID=1005 \
              thomfab/docker-syncthing
```
Files created in the /Sync volume will belong to the user ubuntu (and group users, see below).

### GROUP
By default the group "users" (with id 100) is used. You can also customize and pass a group (and its id) of the docker host.
Example, if your docker host has a group "mygroup" with id 1005 you can use :
```
docker run -d --name syncthing \
              -p 8384:8384 -p 22000:22000 \
              -p 21025:21025/udp -p 21026:21026/udp -p 22026:22026/udp \
              -v /path/to/syncthing/data:/Sync \
              -v /path/to/syncthing/conf:/syncthing-conf \
              -e SYNCTHING_USER=myuser -e SYNCTHING_USERID=1005 \
              -e SYNCTHING_GROUP=mygroup -e SYNCTHING_GROUPID=1005 \
              thomfab/docker-syncthing
```
Files created in the /Sync volume will belong to the group mygroup.
