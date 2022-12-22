#!/bin/bash
# installs desired containers


#TODO prompt user with read command to select download , config , and media directories

# variables




#read -p "Please enter your desired config directory location"





# calibre
---
version: "2.1"
services:
  calibre:
    image: lscr.io/linuxserver/calibre:latest
    container_name: calibre
    #security_opt:
    # - seccomp:unconfined 
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=$(cat /etc/timezone)
    volumes:
      - $CONFIG/calibre:/config
    ports:
      - 8081:8080
      - 8082:8081
    restart: always


# jellyfin
---
version: "2.1"
services:
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=1005
      - PGID=1101
      - TZ=$(cat /etc/timezone)
      - JELLYFIN_PublishedServerUrl=
    volumes:
      - $CONFIG/jellyfin:/config
      - $MEDIA/tv:/data/tvshows,ro
      - $MEDIA/movies:/data/movies,ro
    devices:
      - /dev/dri/renderD128:/dev/dri/renderD128
      - /dev/dri/card0:/dev/dri/card0
    ports:
      - 8096:8096
    restart: always


# lidarr
---
version: "2.1"
services:
  lidarr:
    image: lscr.io/linuxserver/lidarr:latest
    container_name: lidarr
    environment:
      - PUID=1007
      - PGID=1101
      - TZ=$(cat /etc/timezone)
    volumes:
      - $CONFIG:/config
      - $MEDIA/music:/music
      - $DOWNLOADS:/downloads
    ports:
      - 8686:8686
    restart: always


# radarr
---
version: "2.1"
services:
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1004
      - PGID=1101
      - TZ=$(cat /etc/timezone)
    volumes:
      - $CONFIG/radarr:/config
      - $MEDIA/movies:/movies
      - $DOWNLOADS:/downloads
    ports:
      - 7878:7878
    restart: always


# readarr
---
version: "2.1"
services:
  readarr:
    image: lscr.io/linuxserver/readarr:develop
    container_name: readarr
    environment:
      - PUID=1008
      - PGID=1101
      - TZ=$(cat /etc/timezone)
    volumes:
      - $CONFIG/readarr:/config
      - $MEDIA/books:/books 
      - $DOWNLOADS:/downloads
    ports:
      - 8787:8787
    restart: always


# sabnzbd
---
version: "2.1"
services:
  sabnzbd:
    image: lscr.io/linuxserver/sabnzbd:latest
    container_name: sabnzbd
    environment:
      - PUID=1006
      - PGID=1101
      - TZ=$(cat /etc/timezone)
    volumes:
      - $CONFIG/sabnzbd:/config
      - $DOWNLOADS:/downloads
      - $DOWNLOADS/incomplete:/incomplete-downloads 
    ports:
      - 8080:8080
    restart: always


# sonarr
---
version: "2.1"
services:
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1003
      - PGID=1101
      - TZ=$(cat /etc/timezone)
    volumes:
      - $CONFIG/sonarr:/config
      - $MEDIA/tv:/tv
      - $DOWNLOADS:/downloads 
    ports:
      - 8989:8989
    restart: always


# transmission
---
version: "2.1"
services:
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    environment:
      - PUID=1002
      - PGID=1101
      - TZ=$(cat /etc/timezone)
      - TRANSMISSION_WEB_HOME=/flood-for-transmission/
    volumes:
      - $CONFIG/transmission:/config
      - $DOWNLOADS:/downloads
    ports:
      - 9091:9091
      - 51413:51413
      - 51413:51413/udp
    restart: always 



# ensures correct permissions to execute script 
function check-root(){

    if [ "$EUID" -ne 0 ]

    then echo "incorrect permissions, Please run as root by then run the script again"; exit

    fi

}


function prompt(){

    read -p "Would you like to install $CONTAINER (y/n)? " answer
    case ${answer:0:1} in
      y|Y )
          echo "========================"
          echo " installing $CONTAINER"
          echo "========================"
          #function for container install
          sleep 3
      ;;
      * )
          echo "========================"
          echo "   continuing script    "
          echo "========================"
          sleep 3
      ;;
    esac 

}

# For loop for every single yml? or If statement using case function 