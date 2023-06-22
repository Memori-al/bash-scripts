#!/bin/bash

_Split() {
    # Split Mysql.tar.gz
    split -n 2 -d -a 1 $data_path/mysql-5.6.24.tar.gz $data_path/mysql-5.6.24.tar.gz.part-
    rm -rf $data_path/mysql-5.6.24.tar.gz
    pwd
    ls -al $data_path/ | grep part*
}

_Merge() {
    # merge Mysql.tar.gz
    cat $data_path/*part* > $data_path/mysql-5.6.24.tar.gz
    rm -rf $data_path/*part*
    pwd
    ls -al $data_path/ | grep mysql
}

_Ins() {
    # Install APM
    packages=("httpd" "mariadb-server" "php" "mariadb")
    for package in "${packages[@]}";
    do
        if [[ ! $(rpm -qa | grep $package) ]]; then
            if [[ $package == "php" ]]; then
                yum install -y $package* --skip-broken
            else    
                yum install -y $package
            fi
        fi
    done

    # Update $DIRECTORY Src
    if [[ -f "/var/www/html/$FILES" ]]; then
        if [[ ! $(diff -q $data_path/$FILES /var/www/html/$FILES) ]]; then
            cp -rf $data_path/$FILES /var/www/html
            tar -xvf /var/www/html/$FILES -C /var/www/html
            chmod -R 777 /var/www/html/$DIRECTORY
        fi
    else
        cp -rf $data_path/$FILES /var/www/html
        tar -xvf /var/www/html/$FILES -C /var/www/html
        chmod -R 777 /var/www/html/$DIRECTORY
    fi

    # Httpd Settings
    if [[ ! $(diff -q $data_path/httpd.conf /etc/httpd/conf/httpd.conf) ]]; then
        cp -rf $data_path/httpd.conf /etc/httpd/conf
        ls -al /etc/httpd/conf | grep httpd.conf
    fi
    
    # DB Restore
    if [[ $(rpm -qa | grep mariadb) ]]; then
        systemctl restart mariadb
        mysql_secure_installation
        mysql -u root -p < $data_path/backup.dmp
        systemctl restart mariadb
        systemctl restart httpd
        setenforce 0
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