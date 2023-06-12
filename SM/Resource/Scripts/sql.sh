#!/bin/bash
sqlplus -S sys as sysdba/wjsansrk << SQL
CREATE TABLE final_record (
  수번 VARCHAR2(10),
  이름 VARCHAR2(15),
  학년 INT,
  그룹 VARCHAR2(10),
  학점 VARCHAR2(15)
);
SQL

cat > load_data.ctl << EOF
LOAD DATA
INFILE 'data.txt'
APPEND
INTO TABLE final_record
FIELDS TERMINATED BY '\t'
(수번, 이름, 학년, 그룹, 학점)
EOF

# SQL Loader "load_data.ctl" load
sqlldr control=load_data.ctl

# load_data.ctl delete
rm -rf ./load_data.ctl