#!/bin/bash
# setup personal debian servers 

# variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin
tab=/etc/crontab

# exit if errors during script 
set -e 

# intro prompt 
cat <<"EOF" 

============================================

 This script will update, performance tune,
     and add a mx downtime @0200L-0230L 
        every Monday for this server

============================================

EOF
sleep 6


# ensures correct permissions to execute script 
function check-root(){

    if [ "$EUID" -ne 0 ]

    then echo "incorrect permissions, Please run as root by then run the script again"; exit

    fi

}


# installs system packages and updates
function pkgs(){

    echo "==============="
    echo "updating server"
    echo "==============="
    sleep 5
    apt install curl tuned needrestart -y && apt update -y && apt upgrade -y && apt autoremove -y	

}


# adds to system schedule to update and reboot every monday @0200L
function cron(){

    echo "# updates entire system and reboots every monday @0200L" >> $tab
    echo "  0  2  *  *  1 root       apt update -y && apt upgrade -y && systemctl reboot" >> $tab

}


# locks root account and extends $PATH
function pass(){

    echo "extending PATH, please enter your username"
    sleep 1
    read -p "username : " user 
    echo "export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin/:usr/local/bin/" >> /home/"$user"/.bashrc

    echo "locking root account"
    sleep 2
    passwd -l root

}


# install tailscale VPN
function tail(){

    echo "Would you like to install Tailscale VPN?"
  select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "========================"
              echo "installing tailscale vpn"
              echo "========================"
              sleep 5
              curl -fsSL https://tailscale.com/install.sh | sh; break;;
        No )  echo "========================"
              echo "   continuing script    "
              echo "========================";;
    esac
  done
}


# install docker
function dock(){

    echo "================="
    echo "Installing docker"
    echo "================="
    sleep 5
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
if check-root && pass && cron && pkgs && tail && dock

then cat <<"EOF"

    ================================

            SCRIPT COMPLETED
            REBOOTING SERVER

    ================================

EOF
    sleep 2
    systemctl reboot

else echo "script failed ;(" 

fi