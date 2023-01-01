#!/bin/bash
# update docker container script


# variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin


# script
# TODO : reference $CONFIG instead of apps/*
for CONTAINER in /home/$(logname)/config/apps/*
do
    docker compose --project-directory $CONTAINER pull
    docker compose --project-directory $CONTAINER up -d

done


docker image prune