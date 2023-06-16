#!/bin/bash

# 예외 처리 핸들러
if [[ ! -d "/sm-shell" ]]; then
    _Handler /sm-shell "$(date '+%H:%M:%S')" Directory
    mkdir /sm-shell
elif [[ ! -d "/sm-shell/Resource" ]]; then
    _Handler /sm-shell/Resource "$(date '+%H:%M:%S')" Directory
    mkdir /sm-shell/Resource
elif [[ ! -d "/sm-shell/Resource/Rpm" ]]; then
    _Handler /sm-shell/Resource/Rpm "$(date '+%H:%M:%S')" Directory
    mkdir /sm-shell/Resource/Rpm
fi

mv /etc/yum.repo.d/* /sm-shell # 이전 레포 이동
cp /sm-shell/Resource/Data/local.repo /etc/yum.repos.d # 레포 복붙
yum clean all # 레포 리스트 초기화
yum repolist # 레포리스트 구성
echo -e "$white$b_green"" Complete$cls  repo composition!"

# 마운트 > starter.sh repo > 구성 > 언마운트