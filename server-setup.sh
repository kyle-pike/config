#!/bin/bash

### Pike's Server config ###
### requirements, rhel based server ### 

# goals
# move to ansible 
# put updates on log and to standard output 
#


# variables #
log=/home/$USER/log
dconf=/etc/dnf/dnf.conf


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
    gpgcheck=2
    installonly_limit=4
    clean_requirements_on_remove=True
    best=True
    skip_if_unavailable=False

    # custom edits
    max_parallel_downloads=21
    fastestmirror=True
    } > $dconf

}

# updates system and install neccessary software 
function update(){

    dnf upgrade && dnf install epel-release -y\
    && dnf install dnf install ranger ncdu\
    vim dnf-automatic policycoreutils-python-utils bash-completion -y

}


### script ### 

if check-root

then 
    dnf-setup && update 

else 
    echo "script failed"

fi 
