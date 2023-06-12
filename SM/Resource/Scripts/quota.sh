#!/bin/bash

_QInstall() {
    yum install -y quota
    mkdir /quotahome
    useradd -d /quotahome/csejj csejj
    useradd -d /quotahome/samuel samuel
    useradd -d /quotahome/luikie luikie
    groupadd linuxadmin
    groupadd linuxuser
    chgrp linuxadmin /quotahome/samuel 
    chgrp linuxuser /quotahome/csejj 
    usermod -a -G linuxuser csejj
    usermod -a -G linuxadmin samuel
    chmod g+s /quotahome/csejj
}

_QSettings() {
    echo $2 /quotahome ext4 defaults,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0 1 2 >> /etc/fstab
    mount -o remount,usrjquota,grpjquota $2
    quotaoff -avug
    quotacheck -augmn
    rm -rf aquota.*
    quotacheck -augmn

    touch aquota.user aquota.group
    chmod 600 aquota.*

    quotacheck -augmn
    quotaon -avug

    setquota -g linuxuser 10M 10M 20 20 /quotahome
    setquota -u samuel 0 0 10 10 /quotahome
    setquota -u luikie 0 0 0 0 /quotahome
}

# 전달된 파라미터 필터링
if [[ "$1" == "install" ]]; then
    _QInstall
elif [[ "$1" == "set" ]]; then
    _QSettings $1 $2
fi