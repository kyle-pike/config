#!/usr/bin/env bash


# ensures correct permissions to execute script 
function check-root(){

    if [ "$EUID" -ne 0 ]

    then echo "incorrect permissions, Please run as root by then run the script again"; exit

    fi

}