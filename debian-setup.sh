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

    if [[ $UID != 0 ]]

    then echo "incorrect permissions, Please run as root by then run the script again"; exit

    fi

}


# locks root account and extends $PATH
function lock_password(){
    
    echo "export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin/:usr/local/bin/" >> /home/$(logname)/.bashrc
    echo "===================="
    echo "locking root account"
    echo "===================="
    passwd -l root

}


# adds to system schedule to update and reboot every monday @0200L
function cron(){

    echo "# updates entire system and reboots every monday @0200L" >> $tab
    echo "  0  2  *  *  1 root       apt update -y && apt upgrade -y && systemctl reboot" >> $tab

}


# installs system packages and updates
function update_pkgs(){

    echo "==============="
    echo "updating server"
    echo "==============="
    apt install curl tuned needrestart -y && apt update -y && apt upgrade -y && apt autoremove -y	

}


# optionally install tailscale VPN
function install_tailscale(){

    read -p "Would you like to install Tailscale VPN (y/n)? " answer
    case ${answer:0:1} in
      y|Y )
          echo "========================"
          echo "installing tailscale vpn"
          echo "========================"
          curl -fsSL https://tailscale.com/install.sh | sh
      ;;
      * )
          echo "========================"
          echo "   continuing script    "
          echo "========================"
          sleep 2
      ;;
    esac 

}


# optionally install avahi for mDNS
function install_avahi(){

    read -p "Would you like to install avahi-mDNS (y/n)? If you do not have a local DNS server please select yes" answer
    case ${answer:0:1} in
      y|Y )
          echo "============================"
          echo "installing avahi mDNS daemon"
          echo "============================"
          apt install avahi-daemon
      ;;
      * )
          echo "========================"
          echo "   continuing script    "
          echo "========================"
          sleep 2
      ;;
    esac 

}


# install docker
function install_docker(){

    echo "================="
    echo "Installing docker"
    echo "================="
    sleep 2
    apt install -y ca-certificates curl gnupg lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list >/dev/null
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

}


# script 
### TODO firewall
if check-root && lock_password && cron && update_pkgs && install_tailscale && install_avahi && install_docker

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