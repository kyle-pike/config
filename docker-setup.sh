#!/bin/bash
# installs desired containers

# variables
ENV_FILE=/home/$(logname)/config/apps/.env
TAB=/etc/crontab
HOME_DIR=/home/$(logname)
DAEMON=/etc/docker/daemon.json



# exit if errors during script
set -e


# ensures correct permissions to execute script
function check-root(){

    if [[ $UID != 0 ]]

    then echo "incorrect permissions, Please run as root by then run the script again"; exit

    fi

}


# sets directories to use for docker and places in environment file
function docker_env(){

mkdir -m 775 -p $HOME_DIR/downloads/incomplete
chmod 775 $HOME_DIR/downloads
chown -R 1000:1000 $HOME_DIR/downloads/

read -p "Please enter desired location for the media directory: " MEDIA

for txt in $ENV_FILE
do

    sed -i "s.tz.$(cat /etc/timezone).g" "$ENV_FILE"
    sed -i "s.downloads./home/$(logname)/downloads.g" "$ENV_FILE"
    sed -i "s.config./home/$(logname)/config.g" "$ENV_FILE"
    sed -i "s.media.${MEDIA}.g" "$ENV_FILE"
    
done

for FOLDERS in $HOME_DIR/config/apps/*
do cp $HOME_DIR/config/apps/.env $FOLDERS
done

}


# adds to system schedule to update and reboot every monday @0200L
function cron_docker(){

    touch $HOME_DIR/log
    chown root:root $HOME_DIR/config/docker-update.sh
    echo "# updates docker containers every monday @0300L" >> $TAB
    echo "  0  3  *  *  1 root       $HOME_DIR/config/docker-update.sh" >> $TAB
    
}


# configure docker for user namespaces 
function namespaces(){

echo {                       >> $DAEMON
echo "  "'"userns-remap"' : '"1000"' >> $DAEMON
echo }                       >> $DAEMON

systemctl restart docker.s*

}


# setup system accounts for user namespaces
function permissions(){
    
    groupadd -g 100000 fake_root
    groupadd -g 100999 calibre
    groupadd -g 101000 media
    
    useradd -u 100000 -g fake_root -r -s /usr/sbin/nologin fake_root
    useradd -u 100999 -g calibre -r -s /usr/sbin/nologin calibre
    useradd -u 101000 -g media -r -s /usr/sbin/nologin sabnzbd
    useradd -u 101100 -g media -r -s /usr/sbin/nologin transmission
    useradd -u 101200 -g media -r -s /usr/sbin/nologin sonarr
    useradd -u 101300 -g media -r -s /usr/sbin/nologin radarr
    useradd -u 101400 -g media -r -s /usr/sbin/nologin lidarr
    useradd -u 101500 -g media -r -s /usr/sbin/nologin jellyfin
    useradd -u 101600 -g media -r -s /usr/sbin/nologin readarr

    # change ownership of config file?

    # change ownership of download to sabnzdb:media? what about transmission
    chmod -R sabnzdb:media $HOME_DIR/downloads

}


# installs containers
function install_containers(){

for CONTAINER in $HOME_DIR/config/apps/*
do

    read -p "Would you like to install $CONTAINER (y/n)? " answer
    case ${answer:0:1} in
      y|Y )
          echo "=========================================="
          echo " installing $CONTAINER  "
          echo "=========================================="
          docker compose --project-directory $CONTAINER pull
          docker compose --project-directory $CONTAINER up -d
       
      ;;
      * )
          echo "========================"
          echo "   continuing script    "
          echo "========================"
      ;;
    esac

done

}


# script
# TODO : create locked user accounts per container, dashdot for monitoring, homarr, intend for script to be reran
# !!! chown for who owns what folders, ie sabnzdb:media
check-root && docker_env 

# install_containers

cron_docker

cat <<"EOF"

================================

       SCRIPT COMPLETED

================================

EOF

sleep 2