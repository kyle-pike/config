#!/bin/bash
# installs desired containers

# variables
ENV_FILE=apps/.env

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

read -p "Please enter desired location for the downloads directory: " DOWNLOADS

read -p "Please enter desired location for the config directory: " CONFIG

read -p "Please enter desired location for the media directory: " MEDIA


for txt in $ENV_FILE
do

    sed -i "s.tz.$(cat /etc/timezone).g" "$ENV_FILE"
    sed -i "s.downloads.${DOWNLOADS}.g" "$ENV_FILE"
    sed -i "s.config.${CONFIG}.g" "$ENV_FILE"
    sed -i "s.media.${MEDIA}.g" "$ENV_FILE"

done

}


# script
check-root && docker_env


for CONTAINER in apps/*
do

    read -p "Would you like to install $CONTAINER (y/n)? " answer
    case ${answer:0:1} in
      y|Y )
          echo "========================"
          echo " installing $CONTAINER  "
          echo "========================"
          cd $CONTAINER
          docker compose pull
          docker compose up -d
          cd ..
      ;;
      * )
          echo "========================"
          echo "   continuing script    "
          echo "========================"
          sleep 2
      ;;
    esac

done

then cat <<"EOF"

    ================================

            SCRIPT COMPLETED

    ================================

EOF
    sleep 2