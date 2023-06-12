#!/bin/bash
    # Data : packages.txt, local-repo.repo, httpd.conf, *.ora, oratab, .bash_profile

# 스크립트 동작부
_Init() {
    source /sm-shell/Resource/Scripts/color.sh

    # 전달된 파라미터 값 확인 후 매치
    if [[ "$1" == "rpm" ]]; then # 첫번째로 전달된 인자가 rpm 일 때
        rpm -qa > /sm-shell/SM"$CID"-"$NAME"-rpm-list.log
    elif [[ "$1" == "oracle" ]]; then # 첫번째로 전달된 인자가 oracle 일 때
        if [[ "$2" == "install" ]]; then
            source /sm-shell/Resource/Scripts/oracle.sh install 2>> /sm-shell/Oracle_"$(date +"%m%d")".log
        elif [[ "$2" == "setdb" ]]; then
            source /sm-shell/Resource/Scripts/oracle.sh setdb 2>> /sm-shell/Oracle_"$(date +"%m%d")".log
        elif [[ "$2" == "sorting" ]]; then
            source /sm-shell/Resource/Scripts/oracle.sh sorting 2>> /sm-shell/Oracle_"$(date +"%m%d")".log
        else # 두번째로 전달된 인자가 조건문에 존재하지 않을 때
            source /sm-shell/Resource/Scripts/messages.sh oracle
            exit 1
        fi
    elif [[ "$1" == "repo" ]]; then
        source /sm-shell/Resource/Scripts/repo.sh
    elif [[ "$1" == "apm" ]]; then # 첫번째로 전달된 인자가 apm 일 때
        if [[ "$2" == "install" ]]; then
            source /sm-shell/Resource/Scripts/apm.sh install 2>$1 >> /sm-shell/APM_"$(date +"%m%d")".log
        elif [[ "$2" == "split" ]]; then
            source /sm-shell/Resource/Scripts/apm.sh split 2>$1 >> /sm-shell/APM_"$(date +"%m%d")".log
        elif [[ "$2" == "merge" ]]; then
            source /sm-shell/Resource/Scripts/apm.sh merge 2>$1 >> /sm-shell/APM_"$(date +"%m%d")".log
        elif [[ "$2" == "check" ]]; then
            _Check
        else # 두번째로 전달된 인자가 조건문에 존재하지 않을 때
            source /sm-shell/Resource/Scripts/messages.sh apm
            exit 1
        fi
    elif [[ "$1" == "quota" ]]; then # 첫번째로 전달된 인자가 quota 일 때
        if [[ $2 == "install" ]]; then
            source /sm-shell/Resource/Scripts/quota.sh install 2>$1 >> /sm-shell/Quota_"$(date +"%m%d")".log
        elif [[ $2 == "set" ]]; then
            source /sm-shell/Resource/Scripts/quota.sh set 2>$1 >> /sm-shell/Quota_"$(date +"%m%d")".log
        fi
    elif [[ "$1" == "sendmail" ]]; then # 첫번째로 전달된 인자가 sendmail 일 때
        source /sm-shell/Resource/Scripts/sendmail.sh 2>$1 >> /sm-shell/Sendmail_"$(date +"%m%d")".log
    elif [[ "$1" == "mail" ]]; then # 첫번째로 전달된 인자가 mail 일 때
        if [[ "$2" == "send" ]]; then
            source /sm-shell/Resource/Scripts/mail.sh send $3 $4 $5 2>$1 >> /sm-shell/Mail_Tranfer_"$(date +"%m%d")".log
        fi
    else # 첫번째로 전달된 인자가 조건문에 존재하지 않을 때
        echo -e "$title $1 is available command."
        source /sm-shell/Resource/Scripts/messages.sh $1
        exit 1
    fi
} 2>> /sm-shell/Init_"$(date +"%m%d")".log

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
    if [[ $(rpm -qa | grep php) == "" ]]; then
       _Handler php "$(date '+%H:%M:%S')" install
    fi
} 

# 예외 처리 핸들러
_Handler() {
    echo "[$2] $1 $3 Error" >> /sm-shell/Error_"$(date +"%m%d")".log
    echo -e "$white""$b_red[$2] $1 $3 Error$cls"
} 2>> /sm-shell/Error_"$(date +"%m%d")".log

# 시작 함수
_Init $1 $2 $3 $4 $5