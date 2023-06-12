#!/bin/bash

_Split() {
    # Split Mysql.tar.gz
    split -n 2 -d -a 1 /sm-shell/Resource/Data/mysql-5.6.24.tar.gz mysql-5.6.24.tar.gz.part-
}

_Merge() {
    # merge Mysql.tar.gz
    cat /sm-shell/Resource/Data/*part* > /sm-shell/Resource/Data/mysql-5.6.24.tar.gz
}

_Ins() {
    # Install APM
    yum install -y httpd mariadb php
    
    # Update Xe Src
    cp /sm-shell/Resource/Data/xe.tar.gz /var/www/html
    tar zxvf /var/www/html/xe.tar.gz
    chmod -R 777 /var/www/html/xe

    # Httpd Settings
    cp -rf /sm-shell/Resource/Data/httpd.conf /etc/httpd/conf.d

    # DB Restore
    if [[ $(systemctl is-active mariadb) == "active" ]]; then
        mysql -u root -p wjsansrk < /sm-shell/Resource/Data/db_backup.dmp
    fi
}

if [[ "$1" == "install" ]]; then
    _Ins
elif [[ "$1" == "split" ]]; then
    _Split
elif [[ "$1" == "merge" ]]; then
    _Merge
elif [[ "$1" == "check" ]]; then
    _Check
else
    _Handler apm.sh "$(date '+%H:%M:%S')" Number
fi