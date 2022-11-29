#!/bin/bash
# adjusts putzke's new server/laptop #

# variables
PATH=/sbin:/bin:/usr/sbin:/usr/bin
log=/home/admin/putzke.log
tab=/etc/crontab

# exit if errors during script 
set -e 

# create log file
touch /home/admin/putzke.log

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

# ensures correct permissions to execute script 
function check-root(){

    if [ "$EUID" -ne 0 ]
    then echo "incorrect permissions, Please run as root by executing sudo -i then running the script again"
    exit
fi

}


# updates system and reboots 
function update(){

	
		if
			dnf upgrade -y && dnf autoremove -y 
		then
			echo "================================"
			echo " "		
			echo "        REBOOTING SERVER        "				
		    echo " "
			echo "================================"
			sleep 5 
			systemctl reboot
		else
			echo "server failed to update" >> $log
		fi
}


# adds to system schedule to update and reboot every monday @0200L
function cron(){
	
	echo "# updates entire system and reboots every monday @0200L" >> $tab
	echo "  0  2  *  *  1 root       dnf upgrade -y && shutdown -r" >> $tab
}


# fast af boi
function setup(){

	tuned-adm profile throughput-performance && systemctl enable --now cockpit.socket
}


# changes password for admin account and locks root account
function pass(){

	echo "locking root account"
	sleep 2	
	passwd -l root 
	sleep 2
	echo " "
	cat <<"EOF"
	============================================
	
	 You will be prompted to create a new admin 
		password, DO NOT LOSE THIS!
	
	============================================
	
EOF

	sleep 10
	passwd admin 
} 

function tail(){
	curl -fsSL https://tailscale.com/install.sh | sh
}




# script itself 
if check-root && pass && cron && setup && tail && update 
then echo "GG" >> $log
else echo "script failed" >> $log
fi  
