#!/bin/bash
# update docker container script


# variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin
LOG=/home/$(id -un 1000)/log 


# script
# TODO : reference $CONFIG instead of apps/*

if 

    for CONTAINER in /home/$(id -un 1000)/config/apps/*
    do
        docker compose --project-directory $CONTAINER pull
        docker compose --project-directory $CONTAINER up -d

    done

    docker image prune

then

    echo "containers updated @ [$(date)]" >> $LOG
    echo " " >> $LOG

else

   echo "containers failed to update @ [$(date)]" >> $LOG
   echo " " >> $LOG

fi
