#!/bin/bash
# installs desired containers


# variables
CALIBRE= # insert link 

# exit if errors during script 
set -e 


# ensures correct permissions to execute script 
function check-root(){

    if [ "$EUID" -ne 0 ]

    then echo "incorrect permissions, Please run as root by then run the script again"; exit

    fi

}


# requests what directories to use for docker
function directories(){

read -p "Please enter desired location for the downloads directory: " DOWNLOADS

read -p "Please enter desired location for the config directory: " CONFIG

read -p "Please enter desired location for the media directory: " MEDIA

}


# asks if you would like to install the desired container
function prompt(){

    read -p "Would you like to install $CONTAINER (y/n)? " answer
    case ${answer:0:1} in
      y|Y )
          echo "========================"
          echo " installing $CONTAINER"
          echo "========================"
          container_install
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


# installs the container
function container_install(){

    docker network create $CONTAINER
    docker-compose pull 
    docker-compose up -d 

}


# For loop for every single yml? or If statement using case function 
# for loop goes through text files containing all yml files, do part contains case statement

# script

check-root

directories

for CONTAINER in 
do prompt
done 


# install one container at time or add desired containers to tmp file/variable then
# install all at once?