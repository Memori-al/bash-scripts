#!/bin/bash

_QInstall() {
    users=("samuel" "luikie" "csejj")
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
        mount -o remount,usrjquota,grpjquota $2
        quotaoff -avug
        quotacheck -augmn
        rm -rf aquota.*
        quotacheck -augmn

        touch aquota.user aquota.group
        chmod 600 aquota.*

        quotacheck -augmn
        quotaon -avug
    fi
    
    setquota -g linuxuser 10M 10M 20 20 /quotahome
    setquota -u samuel 0 0 10 10 /quotahome
    setquota -u luikie 0 0 0 0 /quotahome
    echo -e "$white$b_green"" Complete$cls  quota composition!"
}

# 전달된 파라미터 필터링
if [[ "$1" == "install" ]]; then
    _QInstall
elif [[ "$1" == "set" ]]; then
    _QSettings $1 $2
fi