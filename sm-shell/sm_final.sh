#!/bin/bash
#### 서버관리 자동화 SHELL SCRIPTS 시작부     ####
#### AUTHOR : LEE KANG IL / SM15-LUIKIE     ####
#### EMAIL  : lki_familiar@naver.com        ####
#### GIT    : https://github.com/Memori-al  ####

# 스크립트 동작부
_Init() {
    source /sm-shell/Resource/Scripts/settings.sh
    case "$1" in
        "rpm")
            rpm -qa > "/sm-shell/$ID-$NAME-rpm-list.log"
            ;;
        "oracle")
            chmod 777 -R /sm-shell/Log/*
            case "$2" in
                "install" | "setdb" | "sort" | "sql" | "back")
                    source "$shell_path/oracle.sh" "$2" >> "$log_path/Oracle_$(date +"%m%d").log" 2>&1
                    ;;
                *)
                    source "$shell_path/messages.sh" oracle
                    exit 1
                    ;;
            esac
            ;;
        "repo")
            source "$shell_path/repo.sh"
            ;;
        "apm")
            case "$2" in
                "install" | "split" | "merge" | "check")
                    source "$shell_path/apm.sh" "$2" >> "$log_path/APM_$(date +"%m%d").log" 2>&1
                    ;;
                *)
                    source "$shell_path/messages.sh" apm
                    exit 1
                    ;;
            esac
            ;;
        "quota")
            case "$2" in
                "install")
                    source "$shell_path/quota.sh" install >> "$log_path/Quota_$(date +"%m%d").log" 2>&1
                    ;;
                "set")
                    source "$shell_path/quota.sh" set "$3" >> "$log_path/Quota_$(date +"%m%d").log" 2>&1
                    ;;
                *)
                    source "$shell_path/messages.sh" quota
                    exit 1
                    ;;
            esac
            ;;
        "mail")
            case "$2" in
                "send")
                    case "$3" in
                        "local" | "global" | "nofile")
                            source "$shell_path/mail.sh" send "$3" >> "$log_path/Mail_Tranfer_$(date +"%m%d").log" 2>&1
                            ;;
                        *)
                            source "$shell_path/messages.sh" mail
                            exit 1
                            ;;
                    esac
                    ;;
                "install")
                    source "$shell_path/mail.sh" install >> "$log_path/Mail_Tranfer_$(date +"%m%d").log" 2>&1
                    ;;
                *)
                    source "$shell_path/messages.sh" mail
                    exit 1
                    ;;
            esac
            ;;
        "help")
            source "$shell_path/messages.sh" help
            ;;
        *)
            source "$shell_path/messages.sh" "$1"
            exit 1
            ;;
    esac
} 2>> /sm-shell/Log/Init_"$(date +"%m%d")".log

# 예외 처리 핸들러
_Handler() {
    echo "[$2] $1 $3 Error" >> $log_path/Error_"$(date +"%m%d")".log
    echo -e "$white$b_red[$2] $1 $3 Error$cls"
} 2>> $log_path/Error_"$(date +"%m%d")".log

# 시작 함수
_Init $1 $2 $3 $4 $5
