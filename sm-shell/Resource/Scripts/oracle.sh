#!/bin/bash
_OInstall() {
    yum install -y --nogpgcheck $data_path/oracle-database-preinstall-21c-1.0-1.el7.x86_64.rpm 
    yum install -y --nogpgcheck $data_path/oracle-database-ee-21c-1.0-1.ol8.x86_64.rpm
    /etc/init.d/oracledb_ORCLCDB-21c configure &
    usermod -a -G dba oracle
    echo "oracle:wjsansrk" | chpasswd
    cp -rf $data_path/.bash_profile /home/oracle/.bash_profile
}

_ODatabase() {
    source /home/oracle/.bash_profile
    if [[ -f "$log_path/Oracle_DB_S_"$(date +"%m%d")".log" ]]; then
        if [[ $(cat $log_path/Oracle_DB_S_"$(date +"%m%d")".log | grep "") ]]; then
            sqlplus -S / as sysdba << SQL > $log_path/Oracle_DB_S_"$(date +"%m%d")".log
            startup mount;
            ALTER USER sys IDENTIFIED BY wjsansrk;
            commit;
            exit;
SQL
        fi
    fi
    
    file_lists=("listener.ora" "tnsnames.ora" "oratab" "initlinuxDB.ora")
    for file_list in "${file_lists[@]}";
    do
        if [[ $file_list != "oratab" ]]; then
            if [[ ! $(diff -q $data_path/$file_list $ORACLE_HOME/network/admin) ]]; then
                cp -rf $data_path/$file_list $ORACLE_HOME/network/admin
            fi
        elif [[ $file_list == "initlinuxDB.ora" ]]; then
            cp -rf $data_path/initlinuxDB.ora /opt/oracle/dbs/
        else
            if [[ ! $(diff -q $data_path/$file_list /etc/oratab) ]]; then
                cp -rf $data_path/$file_list /etc/oratab
            fi
        fi
    done

    # 예외처리 오류 리스트
    # NID-00106 : 오라클 오류와 함께 DB 로그인 실패
    # ORA-01034 : 오라클 존재하지 않음
    # NID-00135 : 오라클 활성 스레드 오류
    # NID-00121 : 데이터 베이스가 열리면 안됨
    nid target=sys DBNAME=linuxDB > $log_path/Oracle_DB_"$(date +"%m%d")".log
    if [[ ! $(cat $log_path/Oracle_DB_"$(date +"%m%d")".log | grep -o -e "NID-00106" -e "NID-00135" -e "ORA-01034" -e "NID-00121") ]]; then
        sed -i 's/export ORACLE_SID=ORCLCDB/export ORACLE_SID=linuxDB/g' /home/oracle/.bash_profile
        source /home/oracle/.bash_profile
        sqlplust -S / as sysdba << SQL > $log_path/Oracle_DB_S_"$(date +"%m%d")".log
        startup mount;
        ALTER database open resetlogs;
        exit;
SQL
    else
        _Handler oracle "$(date '+%H:%M:%S')" setdb
    fi
}

_OBack() {
    sed -i 's/export ORACLE_SID=linuxDB/export ORACLE_SID=/g' /home/oracle/.bash_profile
    source /home/oracle/.bash_profile
}

_OSql() {
    sqlplus -S / as sysdba << SQL
    CREATE TABLE final_record (수번 VARCHAR2(10),이름 VARCHAR2(15),학년 INT,그룹 VARCHAR2(10),학점 VARCHAR2(15));
SQL

    cat > $data_path/load_data.ctl << EOF
    LOAD DATA
    INFILE '$data_path/score.txt'
    APPEND
    INTO TABLE final_record
    FIELDS TERMINATED BY '\t'
    (수번, 이름, 학년, 그룹, 학점)
EOF

    # SQL Loader "load_data.ctl" load
    sqlldr control=$data_path/load_data.ctl
}

_OSort() {
    head -n 5 $data_path/score.txt > /sm-shell/score-1.txt
    tail -n 5 $data_path/score.txt > /sm-shell/score-2.txt
    sort -k3,3n -k4,4 /sm-shell/score_1.txt > /sm-shell/score_result.txt
    sort -k2,2 -k3,3n /sm-shell/score_2.txt >> /sm-shell/score_result.txt
    rm -rf /sm-shell/score-*.txt
}

# 전달된 파라미터 필터링
if [[ "$1" == "install" ]]; then
    _OInstall
elif [[ "$1" == "sort" ]]; then
    _OSort
fi
if [[ $(whoami) != "root" ]]; then
    if [[ "$1" == "setdb" ]]; then
        _ODatabase
    elif [[ "$1" == "sql" ]]; then
        _OSql
    elif [[ "$1" == "back" ]]; then
        _OBack
    else
        source $shell_path/messages.sh oracle
    fi
    echo -e "$white$b_red"" Warning $cls  root accounts."
fi