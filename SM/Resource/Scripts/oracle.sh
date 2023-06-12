#!/bin/bash
_OInstall() {
    yum install -y --nogpgcheck /sm-shell/Resource/Rpm/oracle-database-preinstall-21c-1.0-1.el7.x86_64.rpm
    yum install -y --nogpgcheck /sm-shell/Resource/Rpm/oracle-database-ee-21c-1.0-1.ol8.x86_64.rpm
    usermod -a -G dba oracle
    echo "oracle:wjsansrk" | chpasswd
    /etc/init.d/oracledb_ORCLCDB-21c configure
    cp -rf /sm-shell/Resource/Data/.bash_profile /home/oracle/.bash_profile
    source /home/oracle/.bash_profile
}

_ODatabase() {
    sqlplus -S sys as sysdba/wjsansrk << SQL
    startup mount;
    create pfile='/opt/oracle/dbs/initlinuxDB.ora' from spfile;
SQL
    nid target=sys/wjsansrk DBNAME=linuxDB
    cp -rf /sm-shell/Resource/Data/listener.ora $ORACLE_HOME/network/admin
    cp -rf /sm-shell/Resource/Data/tnsnames.ora $ORACLE_HOME/network/admin
    cp -rf /sm-shell/Resource/Data/oratab /etc/oratab
    export $OLACLE_SID=linuxDB
    source /home/oracle/.bash_profile
}

_OSql() {
    sqlplus -S sys as sysdba/wjsansrk << SQL
    CREATE TABLE final_record (
    수번 VARCHAR2(10),
    이름 VARCHAR2(15),
    학년 INT,
    그룹 VARCHAR2(10),
    학점 VARCHAR2(15)
    );
SQL

    cat > /sm-shell/Resource/Data/load_data.ctl << EOF
    LOAD DATA
    INFILE '/sm-shell/Resource/Data/score.txt'
    APPEND
    INTO TABLE final_record
    FIELDS TERMINATED BY '\t'
    (수번, 이름, 학년, 그룹, 학점)
EOF

    # SQL Loader "load_data.ctl" load
    sqlldr control=load_data.ctl
}

_OSort() {
    head -n 5 /sm-shell/Resource/Data/score.txt > /sm-shell/score_1.txt
    tail -n 5 /sm-shell/Resource/Data/score.txt > /sm-shell/score_2.txt
    sort -k3,3n -k4,4 /sm-shell/score_1.txt > /sm-shell/score_result.txt
    sort -k2,2 -k3,3n /sm-shell/score_2.txt >> /sm-shell/score_result.txt
    rm -rf /sm-shell/sort_data_*.txt
}

# 전달된 파라미터 필터링
if [[ "$1" == "install" ]]; then
    _OInstall
elif [[ "$1" == "setdb" ]]; then
    _ODatabase
elif [[ "$1" == "sql" ]]; then
    _OSql
elif [[ "$1" == "sort" ]]; then
    _OSort
fi