#!/bin/bash
#### 서버관리 자동화 SHELL SCRIPTS 시작부     ####
#### AUTHOR : LEE KANG IL / SM15-LUIKIE     ####
#### EMAIL  : lki_familiar@naver.com        ####
#### GIT    : https://github.com/Memori-al  ####

# 스크립트 동작부
_Init() {
    source /sm-shell/Resource/Scripts/settings.sh
    # 전달된 파라미터 값 확인 후 매치
    if [[ "$1" == "rpm" ]]; then # 첫번째로 전달된 인자가 rpm 일 때
        rpm -qa > /sm-shell/"$ID"-"$NAME"-rpm-list.log
    elif [[ "$1" == "oracle" ]]; then # 첫번째로 전달된 인자가 oracle 일 때
        if [[ "$2" == "install" ]]; then
            source $shell_path/oracle.sh install 2>> $log_path/Oracle_"$(date +"%m%d")".log
        elif [[ "$2" == "setdb" ]]; then
            source $shell_path/oracle.sh setdb 2>> $log_path/Oracle_"$(date +"%m%d")".log
        elif [[ "$2" == "sort" ]]; then
            source $shell_path/oracle.sh sort 2>> $log_path/Oracle_"$(date +"%m%d")".log
        elif [[ "$2" == "sql" ]]; then
            source $shell_path/oracle.sh sql 2>> $log_path/Oracle_"$(date +"%m%d")".log
        elif [[ "$2" == "back" ]]; then
            source $shell_path/oracle.sh sort 2>> $log_path/Oracle_"$(date +"%m%d")".log
        else # 두번째로 전달된 인자가 조건문에 존재하지 않을 때
            source $shell_path/messages.sh oracle
            exit 1
        fi
    elif [[ "$1" == "repo" ]]; then
        source $shell_path/repo.sh
    elif [[ "$1" == "apm" ]]; then # 첫번째로 전달된 인자가 apm 일 때
        if [[ "$2" == "install" ]]; then
            source $shell_path/apm.sh install 2>> $log_path/APM_"$(date +"%m%d")".log
        elif [[ "$2" == "split" ]]; then
            source $shell_path/apm.sh split 2>> $log_path/APM_"$(date +"%m%d")".log
        elif [[ "$2" == "merge" ]]; then
            source $shell_path/apm.sh merge 2>> $log_path/APM_"$(date +"%m%d")".log
        elif [[ "$2" == "check" ]]; then
            source $shell_path/apm.sh check 2>> $log_path/APM_"$(date +"%m%d")".log
        else # 두번째로 전달된 인자가 조건문에 존재하지 않을 때
            source $shell_path/messages.sh apm
            exit 1
        fi
    elif [[ "$1" == "quota" ]]; then # 첫번째로 전달된 인자가 quota 일 때
        if [[ $2 == "install" ]]; then
            source $shell_path/quota.sh install 2>> $log_path/Quota_"$(date +"%m%d")".log
        elif [[ $2 == "set" ]]; then
            source $shell_path/quota.sh set $3 2>> $log_path/Quota_"$(date +"%m%d")".log
        else
            source $shell_path/messages.sh quota
            exit 1
        fi
    elif [[ "$1" == "mail" ]]; then # 첫번째로 전달된 인자가 mail 일 때
        if [[ "$2" == "send" ]]; then
            source $shell_path/mail.sh send 2>> $log_path/Mail_Tranfer_"$(date +"%m%d")".log
        elif [[ "$2" == "install" ]]; then
            source $shell_path/mail.sh install 2>> $log_path/Mail_Tranfer_"$(date +"%m%d")".log
        else
            source $shell_path/messages.sh mail
            exit 1
        fi
    elif [[ "$1" == "help" ]]; then
        source $shell_path/messages.sh help
    else # 첫번째로 전달된 인자가 조건문에 존재하지 않을 때
        source $shell_path/messages.sh $1
        exit 1
    fi
} 2>> /sm-shell/Log/Init_"$(date +"%m%d")".log

# 예외 처리 핸들러
_Handler() {
    echo "[$2] $1 $3 Error" >> $log_path/Error_"$(date +"%m%d")".log
    echo -e "$white""$b_red[$2] $1 $3 Error$cls"
} 2>> $log_path/Error_"$(date +"%m%d")".log

# 시작 함수
_Init $1 $2 $3 $4 $5
