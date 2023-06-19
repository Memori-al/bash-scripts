#!/bin/bash

# Variable & File Check Function
Init() {
    s_date=$(date +"%Y-%m") # YYYY-MM Format
    s_date_all=$(date +"%Y-%m-%d") # YYYY-MM-DD Format
    save_path=/home/steam/steamcmd/VRising/VRising/save-data/Saves/v1/world1
    git_path=/home/steam/sh/VRising
    if [ ! -f "/var/log/VMS.$s_date_all.log" ]; then # BK-YY-MM-DD Folder Create
        echo "[$(date '+%H:%M:%S')] Started V Rising Server Management Scripts" > /var/log/VMS.$s_date_all.log
    fi
    if [ ! -d "$git_path/BK-$s_date" ]; then # BK-YY-MM Folder Create
        mkdir $git_path/BK-$s_date
        echo "[$(date '+%H:%M:%S')|Alert] Created $git_path/BK-$s_date directory because it does not exist." >> /var/log/VMS.$s_date_all.log
    fi
    if [ ! -d "$git_path/BK-$s_date_all" ]; then # BK-YY-MM-DD Folder Create
        mkdir $git_path/BK-$s_date_all
        echo "[$(date '+%H:%M:%S')|Alert] Created $git_path/BK-$s_date_all directory because it does not exist." >> /var/log/VMS.$s_date_all.log
    fi
    Loop
}

# Time Check Function
Loop() {
	s_time=$(date +"%H:%M") # HH:MM Format
	if [[ $s_time == "07:00" ]]; then
        echo "[$(date '+%H:%M:%S')] Starting Save Data Backup" >> /var/log/VMS.$s_date_all.log
		Process # Call Server Control Function
        if [ -f $git_path/BK-$s_date/$s_date_all.7z ]; then
            echo "[$(date '+%H:%M:%S')|Success] Save data backup complete in Git repository." >> /var/log/VMS.$s_date_all.log
        else
            echo "[$(date '+%H:%M:%S')|Error] Failed to back up Save Data on Git repository." >> /var/log/VMS.$s_date_all.log
            echo "[$(date '+%H:%M:%S')|Error] $git_path/BK-$s_date/$s_date_all.7z file because it does not exist." >> /var/log/VMS.$s_date_all.log
        fi
        echo "[$(date '+%H:%M:%S')|Alert] The local server and game server have been restarted." >> /var/log/VMS.$s_date_all.log
		# reboot # Server Restart
	fi
    read -t 10 -s
	Loop # Recursion Function
}

# Game Server Control Function
Process() {
	if [[ $(systemctl is-active vrising.service) -eq "active" ]]; then # Server On
		systemctl stop vrising.service
        echo "[$(date '+%H:%M:%S')|Alert] V Rising Service has been stopped." >> /var/log/VMS.$s_date_all.log
		read -t 10 -s # 10 s input waiting = 10 s timeout
		Backup # Save Data Copy
        Git # Git Push
	else # Server Off
		systemctl start vrising.service
	fi
}

# Data Copy Function
Backup() {
    save=$(ls -r $save_path/*.save | head -n 2) # Split String
    for file in $save
    do
        cp -f $file $git_path/BK-$s_date_all # Copy Save Data
    done
    7za a $git_path/BK-$s_date/$s_date_all.7z $git_path/BK-$s_date_all/ # 7Zip Pack
    rm -rf $git_path/BK-$s_date_all/ # Remove Data
}

# Git Upload Function
Git() {
    git add $git_path/BK-$s_date/$s_date_all.7z
    git commit -m "$s_date_all 세이브 파일 백업"
    git push origin main
}

# Call Time Check Function
Init