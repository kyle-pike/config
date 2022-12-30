#!/bin/bash
# update docker container script


# variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin


# script
for CONTAINER in apps/*
do
    docker compose --project-directory $CONTAINER pull
    docker compose --project-directory $CONTAINER up -d

done


docker image prune