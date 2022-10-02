#!/bin/bash

### Pike's Server config ###
### requirements, rhel based server ### 


# variables #
log=/home/$USER/log
dconf=/etc/dnf/dnf.conf


# functions #

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

    dnf update && dnf install epel-release -y\
    && dnf install dnf install ranger ncdu\
    vim dnf-automatic policycoreutils-python-utils bash-completion -y

}
