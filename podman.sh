#!/bin/bash
# updates desired containers


### variables ###

file=/home/podboi/scripts/containers
log=/home/podboi/logs/update.log


### functions ###

# this function pulls the latest container images
function pull(){
for app in $(cat $file)

do
        podman pull $app

done
}


# this function restarts the containers with the latest image
function update(){
for app in $(cat $file)

do
        systemctl --user restart $app
done
}


# this function cleans up unused images and containers
function clean(){
podman image prune -f; podman container prune -f
}


### script ###
if
        pull
then
        update && clean && echo "updated apps at $(date)" >> $log
else
        echo "failed to update apps at $(date)" >> $log
fi