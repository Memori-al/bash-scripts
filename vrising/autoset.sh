#!/bin/bash

# 패키지 설치
Install() {
    wget http://github.com/Memori-al/bash-scripts/packages.txt
    local packages=$(cat ./packages.txt)
    local pack=
    for rpm_pack in $packages
    do
        check=$(rpm -q $rpm_pack|cut -d " " -f4-5)
        if [[ $check == "not installed" ]]; then
            pack+= $pack
        fi
    done
    yum install -y $pack
}

# Steamcmd 설치
Steam() {
    useradd steam
    echo -r "Input Steam User Passwd" | read -r passwd
    echo "steam:$passwd" | chpasswd
    mkdir /home/steam/steamcmd | mkdir /home/steam/steamcmd/VRising | mkdir /home/steam/steamcmd/VRising/save-data/Settings
    wget -O- "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - /home/steam/steamcmd/VRising
    chmod 777 -R /home/steam/steamcmd
    cd /home/steam/steamcmd/VRising/
    ./steamcmd.sh +force_install_dir VRising +quit
    ./steamcmd.sh +login anonymous +app_update 1829350 +quit
}

# 방화벽 설정
Firewall() {
    firewall-cmd --add-port=9876/tcp | firewall-cmd --add-port=9876/udp
    firewall-cmd --add-port=9877/tcp | firewall-cmd --add-port=9877/udp
    firewall-cmd --add-port=3389/tcp | firewall-cmd --add-port=3389/udp
    firewall-cmd --runtime-to-permanent
    firewall-cmd --reload
}

# 서버 설치 및 설정
Server() {
    export WINEARCH=win64
    xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine VRisingServer.exe -persistentDataPath ./save-data -logFile server.log
    read -t 60 -s
    echo '#!/bin/bash' > run.sh
    echo 'xvfm-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine VRisingServer.exe -persistentDataPath ./save-data -logFile server.log' >> run.sh
    echo '[Unit]' > /etc/systemd/system/VRising.service
    echo 'After=network.target' >> /etc/systemd/system/VRising.service
    echo '[Service]' >> /etc/systemd/system/VRising.service
    echo 'User=steam' >> /etc/systemd/system/VRising.service
    echo 'Group=steam' >> /etc/systemd/system/VRising.service
    echo 'WorkingDirectory=/home/steam/steamcmd/VRising' >> /etc/systemd/system/VRising.service
    echo 'ExecStart=/home/steam/steamcmd/VRising/run.sh' >> /etc/systemd/system/VRising.service
    echo '[Install]' >> /etc/systemd/system/VRising.service
    echo 'WantedBy=multi-user.target' >> /etc/systemd/system/VRising.service
    chmod +rwx ./run.sh

    systemctl start VRising.service
    read -t 60 -s
    systemctl stop VRising.service
    systemctl enable VRising.service
}

# 메인 함수
Main() {
    Install
    Steam
    Firewall
    Server
}

# 메인 함수 호출
Main

# packages.txt, run.sh, /etc/systemd/system/VRising.service