#!/bin/bash
# installs desired containers

# variables
ENV_FILE=/home/$(logname)/config/apps/.env
TAB=/etc/crontab
MAIN_FOLDER=/home/$(logname)



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


mkdir -m 775 -p $MAIN_FOLDER/downloads/incomplete
chmod 775 $MAIN_FOLDER/downloads
chown -R 1000:1000 $MAIN_FOLDER/downloads/

read -p "Please enter desired location for the media directory: " MEDIA

for txt in $ENV_FILE
do

    sed -i "s.tz.$(cat /etc/timezone).g" "$ENV_FILE"
    sed -i "s.downloads./home/$(logname)/downloads.g" "$ENV_FILE"
    sed -i "s.config./home/$(logname)/config.g" "$ENV_FILE"
    sed -i "s.media.${MEDIA}.g" "$ENV_FILE"
    
done

}


# adds to system schedule to update and reboot every monday @0200L
function cron_docker(){

    touch $MAIN_FOLDER/log
    chown root:root $MAIN_FOLDER/config/docker-update.sh
    echo "# updates docker containers every monday @0300L" >> $TAB
    echo "  0  3  *  *  1 root       $MAIN_FOLDER/config/docker-update.sh" >> $TAB
    
}


function permissions(){


    # prepare for user namespaces
    {
  "userns-remap": "$(logname)"
    }
    
     >> /etc/docker/daemon.json
    # use variable for creating users ie 
    calibre_uid=101200
    useradd -u $calibre_uid calibre

    # create media group with proper gid
    groupadd media
    # add user, useradd -G $GROUP -r -s /sbin/nologin $USER
    useradd -g $GROUP -r -s /usr/sbin/nologin $USER
    # change ownership of config file?

    # change ownership of download to sabnzdb:media? what about transmission
    groupadd media
    chmod -R sabnzdb:media $MAIN_FOLDER/downloads


}


# script
# TODO : create locked user accounts per container, dashdot for monitoring, homarr, intend for script to be reran
# !!! chown for who owns what folders, ie sabnzdb:media
check-root && docker_env 


for CONTAINER in $MAIN_FOLDER/config/apps/*
do

    read -p "Would you like to install $CONTAINER (y/n)? " answer
    case ${answer:0:1} in
      y|Y )
          echo "========================"
          echo " installing $CONTAINER  "
          echo "========================"
          docker compose --project-directory $CONTAINER pull
          docker compose --project-directory $CONTAINER --env-file $MAIN_FOLDER/config/apps/.env up -d
       
      ;;
      * )
          echo "========================"
          echo "   continuing script    "
          echo "========================"
      ;;
    esac

done

cron_docker

cat <<"EOF"

    ================================

            SCRIPT COMPLETED

    ================================

EOF
    sleep 2