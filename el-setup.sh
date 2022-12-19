#!/bin/bash

### Pike's Server config ###
### requirements, rhel based server ### 

# goals
# move to ansible 
# put updates on log and to standard output 


# variables #
log=/home/$USER/log

# functions #

# check if root 
function check-root(){

    if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

}

# configures dnf to install faster
function dnf-setup(){

    {
    echo " "
    echo "# custom edits #"
    echo "max_parallel_downloads=20"
    echo "fastestmirror=True"
    } >> /etc/dnf/dnf.conf

}

# updates system and install neccessary software 
function pkgs(){

    dnf upgrade -y && dnf install epel-release -y\
    && dnf install ranger ncdu podman podman-compose\
    vim dnf-automatic policycoreutils-python-utils bash-completion\
    setroubleshoot-server setools-console -y

}


### script ### 

if check-root

then 
    dnf-setup && pkgs

else 
    echo "script failed"

fi