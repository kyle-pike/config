#!/bin/bash
# installs desired containers


# exit if errors during script 
set -e 


# source common functions and variables 
source /$HOME/config/common.sh


# requests what directories to use for docker
function directories(){

read -p "Please enter desired location for the downloads directory: " DOWNLOADS

read -p "Please enter desired location for the config directory: " CONFIG

read -p "Please enter desired location for the media directory: " MEDIA

}


# script
check-root && directories


for CONTAINER in /$USER/config/apps/*
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
      ;;
      * )
          echo "========================"
          echo "   continuing script    "
          echo "========================"
          sleep 2
      ;;
    esac 

done