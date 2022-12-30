#!/bin/bash
# setup personal debian servers 

# variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin
tab=/etc/crontab


# exit if errors during script 
set -e 


# source common functions and variables 
source /$HOME/config/common.sh


# intro prompt 
cat <<"EOF" 

============================================

 This script will update, performance tune,
     and add a mx downtime @0200L-0230L 
        every Monday for this server

============================================

EOF
sleep 6


# installs system packages and updates
function pkgs(){

    echo "==============="
    echo "updating server"
    echo "==============="
    sleep 3
    apt install curl tuned needrestart -y && apt update -y && apt upgrade -y && apt autoremove -y	

}


# adds to system schedule to update and reboot every monday @0200L
function cron(){

    echo "# updates entire system and reboots every monday @0200L" >> $tab
    echo "  0  2  *  *  1 root       apt update -y && apt upgrade -y && systemctl reboot" >> $tab

}


# locks root account and extends $PATH
function pass(){

    echo "=========================================="
    echo "extending PATH, please enter your username"
    echo "=========================================="
    read -p "username : " user 
    echo "export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin/:usr/local/bin/" >> /home/"$user"/.bashrc
    echo "===================="
    echo "locking root account"
    echo "===================="
    sleep 3
    passwd -l root

}


# install tailscale VPN
function install_tailscale(){

    read -p "Would you like to install Tailscale VPN (y/n)? " answer
    case ${answer:0:1} in
      y|Y )
          echo "========================"
          echo "installing tailscale vpn"
          echo "========================"
          sleep 3
          curl -fsSL https://tailscale.com/install.sh | sh
      ;;
      * )
          echo "========================"
          echo "   continuing script    "
          echo "========================"
          sleep 3
      ;;
    esac 

}


# install docker
function install_docker(){

    echo "================="
    echo "Installing docker"
    echo "================="
    sleep 3
    apt install -y ca-certificates curl gnupg lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list >/dev/null
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

}


# script 
### TODO supress output?, firewall, docker containers in another script update on crontab
if check-root && pass && cron && pkgs && install_tailscale && install_docker

then cat <<"EOF"

    ================================

            SCRIPT COMPLETED
            REBOOTING SERVER

    ================================

EOF
    sleep 3
    systemctl reboot

else echo "script failed ;(" 

fi