#!/bin/bash
_OInstall() {
    yum install -y --nogpgcheck $data_path/oracle-database-preinstall-21c-1.0-1.el7.x86_64.rpm 
    yum install -y --nogpgcheck $data_path/oracle-database-ee-21c-1.0-1.ol8.x86_64.rpm
    /etc/init.d/oracledb_ORCLCDB-21c configure
    usermod -a -G dba oracle
    echo "oracle:wjsansrk" | chpasswd
    cp -rf $data_path/.bash_profile /home/oracle/.bash_profile
}

_ODatabase() {
    source /home/oracle/.bash_profile
    if [[ -f "$log_path/Oracle_DB_S_"$(date +"%m%d")".log" ]]; then # BS_S 파일이 존재할 때 n 차 실행 시 
        if [[ ! $(cat $log_path/Oracle_DB_S_"$(date +"%m%d")".log | grep "오류") ]]; then # BS_S 로그에 오류 문구 존재하지 않을 때
            sqlplus -S / as sysdba << SQL 
            startup mount;
            ALTER USER sys IDENTIFIED BY wjsansrk;
            commit;
            exit;
SQL
        else
            _Handler oracle "$(date '+%H:%M:%S')" "$(cat $log_path/Oracle_DB_S_"$(date +"%m%d")".log | grep "오류")"
        fi
    else # BS_S 파일이 없을 때 즉 최초 실행 시
        sqlplus -S / as sysdba << SQL 2> $log_path/Oracle_DB_S_"$(date +"%m%d")".log
        startup mount;
        ALTER USER sys IDENTIFIED BY wjsansrk;
        commit;
        exit;
SQL
    fi

    # initlinuxDB.ora /opt/oracle/dbs 경로에 복사
    if [[ ! -f "$data_path/init$DB.ora" ]]; then
        cp -rf $data_path/init$DB.ora /opt/oracle/dbs
        if [[ ! $(cat /etc/opt/oracle/dbs/init$DB.ora | grep "$DB") ]]; then
            sed -i 's/linuxDB/$DB/g' /etc/opt/oracle/dbs/init$DB.ora
        fi
    fi
    
    file_lists=("listener.ora" "tnsnames.ora" "oratab")
    for file_list in "${file_lists[@]}";
    do
        if [[ $file_list != "oratab" ]]; then
            if [[ ! $(diff -q $data_path/$file_list $ORACLE_HOME/network/admin) ]]; then
                cp -rf $data_path/$file_list $ORACLE_HOME/network/admin
            fi
        else
            if [[ ! $(diff -q $data_path/$file_list /etc/oratab) ]]; then
                cp -rf $data_path/$file_list /etc/oratab
            fi
        fi
    done

    # settinsg.ini 의 DB 명이 linuxDB 가 아닐 때
    if [[ $DB != "linuxDB" ]]; then
        sed -i 's/linuxDB.db/$DB.db/g' $ORACLE_HOME/network/admin/listener.ora
        sed -i 's/linuxDB.db/$DB.db/g' $ORACLE_HOME/network/admin/tnsnames.ora
        sed -i 's/linuxDB.db/$DB.db/g' /etc/oratab
    fi

    # 예외처리 오류 리스트
    # ORA-01034 : 오라클 존재하지 않음
    # ORA-01109 : 데이터베이스 개방 오류
    # NID-00106 : 오라클 오류와 함께 DB 로그인 실패
    # NID-00121 : 데이터 베이스가 열리면 안됨
    # NID-00135 : 오라클 활성 스레드 오류
   
    nid target=sys DBNAME=$DB 2> $log_path/Oracle_DB_S_"$(date +"%m%d")".log
    if [[ ! $(cat $log_path/Oracle_DB_"$(date +"%m%d")".log | grep -o -e "NID-00106" -e "NID-00135" -e "ORA-01034" -e "NID-00121") ]]; then
        sed -i 's/export ORACLE_SID=ORCLCDB/export ORACLE_SID=$DB/g' /home/oracle/.bash_profile
        source /home/oracle/.bash_profile
        sqlplus -S / as sysdba << SQL 2> $log_path/Oracle_DB_S_"$(date +"%m%d")".log
        startup mount;
        ALTER database open resetlogs;
        exit;
SQL
    else
        _Handler oracle "$(date '+%H:%M:%S')" "$(cat $log_path/Oracle_DB_"$(date +"%m%d")".log | grep -o -e "NID-00106" -e "NID-00135" -e "ORA-01034" -e "NID-00121")"
    fi
}

_OBack() {
    sed -i 's/export ORACLE_SID=$DB/export ORACLE_SID=ORCLCDB/g' /home/oracle/.bash_profile
    source /home/oracle/.bash_profile
}

_OSql() {
    sqlplus -S / as sysdba << SQL
    CREATE TABLE $TABLE (수번 VARCHAR2(10),이름 VARCHAR2(15),학년 INT,그룹 VARCHAR2(10),학점 VARCHAR2(15));
SQL

    cat > load_data.ctl << EOF
    LOAD DATA
    INFILE '$data_path/score.txt'
    APPEND
    INTO TABLE $TABLE
    FIELDS TERMINATED BY '\t'
    (수번, 이름, 학년, 그룹, 학점)
EOF

    # SQL Loader "load_data.ctl" load
    sqlldr control=load_data.ctl
}

# 알고리즘 수정 필요.
_OSort() {
    # 1 ~ 10 정렬   sort -k3,3n -k4,4
    # 11 ~ 20 정렬  sort -k2,2 -k3,3n
    # 21 ~ 30 정렬  sort -k4,4 -k3,3n
    # 31 ~ 40 정렬  sort -k5,5 -k3,3n
    # 41 ~ 48 정렬  sort -k3,3nr -k4,4
    if [[ $TYPE == "1" ]]; then
        SORT_1="-k3,3n -k4,4"
        SORT_2="-k2,2 -k3,3n"
    elif [[ $TYPE == "2" ]]; then
        SORT_1="-k2,2 -k3,3n"
        SORT_2="-k4,4 -k3,3n"
    elif [[ $TYPE == "3" ]]; then
        SORT_1="-k4,4 -k3,3n"
        SORT_2="-k5,5 -k3,3n"
    elif [[ $TYPE == "4" ]]; then
        SORT_1="-k5,5 -k3,3n"
        SORT_2="-k3,3nr -k4,4"
    fi

    if [[ $TYPE != "0" ]]; then
        head -n $HEAD $data_path/score.txt > /sm-shell/score-1.txt
        tail -n $TAIL $data_path/score.txt > /sm-shell/score-2.txt
        sort $SORT_1 /sm-shell/score_1.txt > /sm-shell/score_result.txt
        sort $SORT_2 /sm-shell/score_2.txt >> /sm-shell/score_result.txt
    else
        sort -k2,2 -k3,3n /sm-shell/score.txt > /sm-shell/score_result.txt
    fi
    rm -rf /sm-shell/score-*.txt
}

# 전달된 파라미터 필터링
chmod 777 -R /sm-shell/Log/*
if [[ "$1" == "install" ]]; then
    _OInstall
elif [[ "$1" == "sort" ]]; then
    _OSort
fi
if [[ $(whoami) == "oracle" ]]; then
    if [[ "$1" == "setdb" ]]; then
        _ODatabase
    elif [[ "$1" == "sql" ]]; then
        _OSql
    elif [[ "$1" == "back" ]]; then
        _OBack
    else
        source $shell_path/messages.sh oracle
    fi
else
    echo -e "$white$b_red"" Warning $cls  only use oracle account."
fi