#!/bin/bash

_Split() {
    # Split Mysql.tar.gz
    split -n 2 -d -a 1 /sm-shell/Resource/Data/mysql-5.6.24.tar.gz /sm-shell/Resource/Data/mysql-5.6.24.tar.gz.part-
    rm -rf /sm-shell/Resource/Data/mysql-5.6.24.tar.gz
    ls -al /sm-shell/Resource/Data/ | grep part*
}

_Merge() {
    # merge Mysql.tar.gz
    cat /sm-shell/Resource/Data/*part* > /sm-shell/Resource/Data/mysql-5.6.24.tar.gz
    rm -rf /sm-shell/Resource/Data/*part*
    ls -al /sm-shell/Resource/Data/ | grep mysql*
}

_Ins() {
    # Install APM
    packages=("httpd" "mariadb-server" "php'*'" "mariadb")
    for package in "${packages[@]}";
    do
        if [[ ! $(rpm -qa | grep $package) ]]; then
            yum install -y $package --skip-broken
        fi
    done

    # Update Xe Src
    if [[ -f "/var/www/html/xe.tar.gz" ]]; then
        if [[ ! $(diff -q /sm-shell/Resource/Data/xe.tar.gz /var/www/html/xe.tar.gz) ]]; then
            cp -rf /sm-shell/Resource/Data/xe.tar.gz /var/www/html
            tar -xvf /var/www/html/xe.tar.gz -C /var/www/html
            chmod -R 777 /var/www/html/xe
        fi
    else
        cp -rf /sm-shell/Resource/Data/xe.tar.gz /var/www/html
        tar -xvf /var/www/html/xe.tar.gz -C /var/www/html
        chmod -R 777 /var/www/html/xe
    fi

    # Httpd Settings
    if [[ ! $(diff -q /sm-shell/Resource/Data/httpd.conf /etc/httpd/conf/httpd.conf) ]]; then
        cp -rf /sm-shell/Resource/Data/httpd.conf /etc/httpd/conf
        ls -al /etc/httpd/conf | grep httpd.conf
    fi
    
    # DB Restore
    if [[ $(systemctl is-active mariadb) == "active" ]]; then
        mysql_secure_installation
        mysql -u root -p dkssud1@ < /sm-shell/Resource/Data/backup.dmp
    fi
    
}

# 오류 처리 함수
_Check() {
    # Function $1 $2 $3 parameters
    if [[ $(systemctl is-active httpd) != "active" ]]; then
        _Handler httpd "$(date '+%H:%M:%S')" service
        systemctl start httpd
    fi
    if [[ $(systemctl is-active mariadb) != "active" ]]; then
        _Handler mariadb "$(date '+%H:%M:%S')" service
        systemctl start mariadb
    fi
    if [[ ! $(rpm -qa | grep php) ]]; then
       _Handler php "$(date '+%H:%M:%S')" install
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
fi