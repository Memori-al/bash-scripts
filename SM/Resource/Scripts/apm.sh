#!/bin/bash

_Split() {
    # Split Mysql.tar.gz
    split -n 2 -d -a 1 /sm-shell/Resource/Data/mysql-5.6.24.tar.gz mysql-5.6.24.tar.gz.part-
    rm -rf /sm-shell/Resource/Data/mysql-5.6.24.tar.gz
    ls -al /sm-shell/Resource/Data | grep mysql*
}

_Merge() {
    # merge Mysql.tar.gz
    cat /sm-shell/Resource/Data/*part* > /sm-shell/Resource/Data/mysql-5.6.24.tar.gz
    rm -rf /sm-shell/Resource/Data/*part*
    ls -al /sm-shell/Resource/Data | grep mysql*
}

_Ins() {
    # Install APM
    packages=("httpd" "mariadb" "php")
    for package in "${packages[@]}";
    do
        if [[ ! $(rpm -qa | grep $package) ]]; then
            yum install -y $package
        fi
    done

    # Update Xe Src
    cp -rf /sm-shell/Resource/Data/xe.tar.gz /var/www/html
    tar zxvf /var/www/html/xe.tar.gz
    chmod -R 777 /var/www/html/xe

    # Httpd Settings
    if [[ ! $(diff -q /sm-shell/Resource/Data/httpd.conf /etc/httpd/conf.d/httpd.conf) ]]; then
        cp -rf /sm-shell/Resource/Data/httpd.conf /etc/httpd/conf.d
        ls -al /etc/httpd/conf.d | grep httpd.conf
    fi

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