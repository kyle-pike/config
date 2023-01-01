#!/bin/bash
# installs desired containers

# variables
ENV_FILE=apps/.env
tab=/etc/crontab

# exit if errors during script
set -e


# ensures correct permissions to execute script
function check-root(){

    if [[ $UID != 0 ]]

    then echo "incorrect permissions, Please run as root by then run the script again"; exit

    fi

}


# requests what directories to use for docker and places in environment file
function docker_env(){

mkdir -p /home/$(logname)/downloads/incomplete

read -p "Please enter desired location for the media directory: " MEDIA

for txt in $ENV_FILE
do

    sed -i "s.tz.$(cat /etc/timezone).g" "$ENV_FILE"
    sed -i "s.downloads.$(cat /home/$logname/downloads).g" "$ENV_FILE"
    sed -i "s.config.$(cat /home/$logname/config).g" "$ENV_FILE"
    sed -i "s.media.${MEDIA}.g" "$ENV_FILE"
    
done

}


# adds to system schedule to update and reboot every monday @0200L
function cron_docker(){

    chown root:root docker-update.sh
    mv docker-update.sh /usr/local/bin/
    echo "# updates docker containers every monday @0300L" >> $tab
    echo "  0  3  *  *  1 root       /usr/local/bin/docker-update.sh" >> $tab

}


# script
# TODO : create locked user accounts per container, dashdot for monitoring, intend for script to be reran
# !!! chown for who owns what folders, ie sabnzdb:media, 775 for downloads
check-root && docker_env 


for CONTAINER in apps/*
do

    read -p "Would you like to install $CONTAINER (y/n)? " answer
    case ${answer:0:1} in
      y|Y )
          echo "========================"
          echo " installing $CONTAINER  "
          echo "========================"
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

cron_docker

cat <<"EOF"

    ================================

            SCRIPT COMPLETED

    ================================

EOF
    sleep 2