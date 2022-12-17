#!/bin/bash
# setup's personal servers for debian based systems
# requirement is debian installed with doas setup

# variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin
tab=/etc/crontab

# exit if errors during script 
set -e 

# intro prompt 
cat <<"EOF" 

============================================

This script will update/reboot,
performance tune and add a mx downtime
@0200L every Monday for this server

============================================
EOF
sleep 10
echo "executing script in 5 ;)"
sleep 1
echo 4 
sleep 1
echo 3
sleep 1
echo 2 
sleep 1
echo 1 

# ensures correct permissions to execute script and extends $PATH
function check-root(){

    if [ "$EUID" -ne 0 ]

    then echo "incorrect permissions, Please run as root by then run the script again"; exit

	fi

}


# updates system and reboots 
function pkgs(){

	 apt install curl tuned needrestart -y && apt update -y && apt upgrade -y && apt autoremove -y	

}


# adds to system schedule to update and reboot every monday @0200L
function cron(){
	
	echo "# updates entire system and reboots every monday @0200L" >> $tab
	echo "  0  2  *  *  1 root       apt update -y && apt upgrade -y && systemctl reboot" >> $tab

}


# locks root account and adds to $PATH
function pass(){

	echo "extending PATH, please enter your username"
	sleep 2
	read -p "username : " user 
	echo "export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin/" >> /home/"$user"/.bashrc
	sleep 2
	
	echo "locking root account"
	sleep 2	
	passwd -l root 
	sleep 2

} 


function tail(){

    echo "installing tailscale vpn"
    sleep 2
	curl -fsSL https://tailscale.com/install.sh | sh

}


function dock(){

	if 
		apt install ca-certificates curl gnupg lsb-release
	    mkdir -p /etc/apt/keyrings
	    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
       
	   	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
   	   
	  	apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

	then echo "Docker has been installed"

	else echo "Docker has failed to install"

	fi 

}



# script 
if check-root && pass && cron && pkgs && tail && dock

then
		
			echo "================================"
			echo " "
			echo "        SCRIPT COMPLETED        "		
			echo "        REBOOTING SERVER        "				
		    echo " "
			echo "================================"
			sleep 5 
			systemctl reboot

else echo "script failed ;(" 

fi