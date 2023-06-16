#!/bin/bash

# Foreground Color
red="\e[91m"
black="\e[30m"
white="\e[97m"
green="\e[92m"
blue="\e[94m"
tear="\e[96m"
yellow="\e[93m"
magenta="\e[95m"
cyan="\e[0;96m"
cls="\e[m"

# Font Styles
bold="\e[1m"
italic="\e[3m"
line="\e[4m"

# Background Color
b_red="\e[41m"
b_green="\e[42m"
b_blue="\e[44m"
b_yellow="\e[43m"
b_magenta="\e[45m"
b_cyan="\e[46m"
b_white="\e[47m"
b_gray="\e[007m"

# '../Data/settings.ini'
src_path="/sm-shell/Resource"
data_path="/sm-shell/Resource/Data"
shell_path="/sm-shell/Resource/Scripts"
log_path="/sm-shell/Log"
set_path="$data_path/settings.ini"
net_path="/etc/sysconfig/network-scripts/ifcfg-enp4s0"


if [[ -f "$set_path" ]]; then
    ID=$(cat $set_path | grep "ID =" | cut -f2 -d "=")
    NICK=$(cat $set_path | grep "NICK =" | cut -f2 -d "=")
    NAME=$(cat $set_path | grep "NAME =" | cut -f2 -d "=")
    IP=$(cat $set_path | grep "IP =" | cut -f2 -d "=")
    TO=$(cat $set_path | grep "TO =" | cut -f2 -d "=")
    FILES=$(cat $set_path | grep "FILES =" | cut -f2 -d "=")
    DIRECTORY=$(cat $set_path | grep "DIRECTORY =" | cut -f2 -d "=")

    variables=("ID" "NICK" "NAME" "IP" "TO" "FILES" "DIRECTORY")
    for space in "${variables[@]}"
    do
        var_value="${!space}"
        var_value=$(echo "$var_value" | sed 's/ //g')
        eval "$space=\"$var_value\""
    done
else
    _Handler '$data_path/settings.ini' "$(date '+%H:%M:%S')" exist
fi

# Network Settings
if [[ $(cat $net_path | grep "BOOTPROTO=dhcp") ]]; then
    sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=none/g' $net_path
    echo "IPADDR=$IP" >> $net_path
    echo "PREFIX=24" >> $net_path
    echo "GATEWAY=202.31.247.254" >> $net_path
    echo "DNS1=202.31.224.3" >> $net_path
    echo "DNS2=202.31.240.2" >> $net_path
    systemctl restart network
fi
