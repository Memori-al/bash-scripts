#!/bin/bash

_QInstall() {
    users=("samuel" "$NICK" "csejj")
    groups=("linuxadmin" "linuxuser")

    # quota 패키지 설치되지 않을 시 설치
    if [[ ! $(rpm -qa | grep quota) ]]; then
        yum install -y quota
    fi

    # quotahome 폴더 존재하지 않을 시 생성
    if [[ ! -d "/quotahome" ]]; then
        mkdir /quotahome
    fi

    # group 배열에 저장된 계정 조건문
    for group in "${groups[@]}";
    do
        if [[ $(group "$group") ]]; then
            groupdel $group
        else
            groupadd $group
        fi
    done

    # user 배열에 저장된 계정 조건문
    for user in "${users[@]}";
    do
        if [[ $(id "$user") ]]; then
            userdel $user
            useradd -d /quotahome/$user $user
            if [[ $user == "csejj" ]]; then
                chgrp linuxuser /quotahome/$user
                chmod g+s /quotahome/$user
                usermod -a -G linuxuser $user
            elif [[ $user == "samuel" ]]; then
                chgrp linuxadmin /quotahome/$user
                usermod -a -G linuxadmin $user
            fi
        else
            useradd -d /quotahome/$user $user
            if [[ $user == "csejj" ]]; then
                chgrp linuxuser /quotahome/$user
                chmod g+s /quotahome/$user
                usermod -a -G linuxuser $user
            elif [[ $user == "samuel" ]]; then
                chgrp linuxadmin /quotahome/$user
                usermod -a -G linuxadmin $user
            fi
        fi
    done
}

_QSettings() {
    if [[ ! $(grep "$2 /quotahome ext4 defaults,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0 1 2" "/etc/fstab") ]]; then
        echo "$2 /quotahome ext4 defaults,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0 1 2">> /etc/fstab
    fi
    mount -o remount $2 > $log_path/Quota_Mount_"$(date +"%m%d")".log
    if [[ ! $(cat $log_path/Oracle_DB_"$(date +"%m%d")".log | grep "") ]]; then
        quotaoff -avug
        quotacheck -augmn
        rm -rf aquota.*
        quotacheck -augmn

        touch aquota.user aquota.group
        chmod 600 aquota.*

        quotacheck -augmn
        quotaon -avug
        setquota -g linuxuser 1M 1M 20 20 /quotahome
        setquota -u samuel 0 0 10 10 /quotahome
        setquota -u $NICK 0 0 0 0 /quotahome
        echo -e "$white$b_green"" Complete$cls  quota composition!"
    else
        _Handler Quota "$(date '+%H:%M:%S')" "$2"_Mount
    fi
}

# 전달된 파라미터 필터링
if [[ $(mount | grep "/quotahome type ext4") ]]; then
    if [[ "$1" == "install" ]]; then
        _QInstall
    elif [[ "$1" == "set" ]]; then
        _QSettings $1 $2
    fi
else
   _Handler Quota "$(date '+%H:%M:%S')" Check_Mount_Partition
fi