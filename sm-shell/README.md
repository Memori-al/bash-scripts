<hr>

# 👁️‍🗨️ Overview
### 🎯 제작 목적
 * 안녕하세요! 😃 전주대학교 **19**학번 **이강일**입니다.<br>
 리눅스를 어려워하는 🌿동기 및 후배분들을 위해 본 스크립트를 제작하게 되었습니다.

 * 본 스크립트는 전주대학교 서버관리 기말시험에 사용되는 자동화 쉘 스크립트입니다.

 * 매년 시험 문제가 바뀌어도 대응할 수 있도록 각 스크립트 부분을 모듈화하여 설계했습니다.

 * 스크립트 사용 시 설치 시간 포함 30~40 분 내에 시험을 끝마칠 수 있습니다.

 [![Up to Date](https://github.com/ikatyang/emoji-cheat-sheet/workflows/Up%20to%20Date/badge.svg)](https://github.com/Memori-al/bash-scripts)
<br> <hr>

### 📑 구현 방법
* 수정 및 추가가 용이한 고가용성(High Available) 코드로 설계했습니다.
    - 스크립트를 `트러블슈팅` 및 `예외처리`하기 쉽도록 설계했습니다.
<br><br>

* 인기있는 `Bash Scripts 표준화 스타일`로 코드를 리터치 했습니다.
    - `Reference Data` **<1번>** 참조
<br><br>

 * `복잡한 파라미터 전달 방식`을 `간소화`하여 스크립트를 쉽게 사용할 수 있도록 **변경**하였습니다. 


 * `파라미터 전달 부분`은 `<settings.ini>` 설정 파일로 대체되어 동적 변수를 사용할 수 있게 되었습니다.
<br><hr>
### ©️ 전자 서명
    * Author    :   이강일
    * Contacts  :   lki_familiar@naver.com
    * Commit    :   23. 06. 19
    * Version   :   2.*
    * License   :   GPL

    * OS        :   Centos 7.*
    * Language  :   Bash Shell
    * Shebang   :   #!/bin/bash
    * Scripts   :   7
    * Indent    :   4
<hr>

# 📜 Contents
## 📖 Theory
* [아키텍처](#-architecture)
    * [도식도](#-architecture-diagram)

## ⚙️ Command Table
* [명령어 표](#%EF%B8%8F-command-table-1)

## 🌱 Configuration
* [settings.sh 초기 설정 방법](#%EF%B8%8F-settingsini-설정)
    * [사용자 설정](#1-사용자-설정)
    * [APM 설정](#2-APM-설정)
    * [메일 설정](#3-메일-설정)
    * [IP 설정](#4-IP-설정)
    * [DB 설정](#5-DB-설정)
    * [정렬 알고리즘](#6-정렬-알고리즘-설정)
    * [(*개발자용) 스크립트 모듈 설정](#7--개발자용--스크립트-모듈-설정)

## 📃 Guide
* [쉘 사용 가이드](#-guide-1)
    * [repo 명령어](#1-repo-명령어)
    * [rpm 명령어](#2-rpm-명령어)
    * [apm 명령어](#3-apm-명령어)
        * split 명령어
        * merge 명령어
        * install 명령어
        * check 명령어
    * [quota 명령어](#4-quota-명령어)
        * 초기 설정
        * install 명령어
        * set 명령어
    * [sendmail 명령어](#5-sendmail-명령어)
        * install 명령어
        * send 명령어
    * [oracle 명령어](#6-oracle-명령어)
        * install 명령어
        * setdb 명령어
        * back 명령어
        * sql 명령어
        * sort 명령어

## 🤗 Standardization
* [표준화](#-standardization-1)
    * [Function Renaming](#1-function-renaming-main)
    * [Exception & Error Handling](#2-exception--error-handling-main)
    * [HA Logging](#3-high-available-main)

## 🔖 Reference
* [Reference Link](#-reference-1)
   * Bash Style 표준화 지침서

<hr>

# 🧱 Architecture
<details>
<summary> View </summary>

## · Architecture Diagram 

AA : 
```mermaid
graph TD;
    sm_final.sh-->settings.sh-->;
    A-->C;
    B-->D;
    C-->D;
```
</details>

<br><hr>

# 🏷️ Command Table
## 🏷️ 명령어 테이블
<details>
<summary> View </summary>

| Command | Parameters $1 | Parameters $2 | Description |
| :---: | :---: | :---: | :---: |
| `repo` | * | * | 로컬 저장소 10초 내에 구성 |
| `rpm` | * | * | 설치된 패키지 목록 저장 |
| `apm` | install | * | APM 서비스 설치 |
| | split | * | MySQL 소스 파일 두 개로 분할 |
| | merge | * | 두 개로 분할한 MySQL 소스 파일 병합 |
| | check | * | APM 서비스 장애 유무 확인 |
| `quota` | install | * | Quota 서비스 설치 |
| | set | `/dev/sda3` | 파라미터 $2 기반으로 Quota 자동 설정 |
| `mail` | install | * | 설치된 패키지 목록 저장 |
| | send | local | <`settings.ini`> 설정 파일 <br>`root@localhost.localdomain` 계정으로 TO = `lki_familiar@naver.com` 주소로 송부합니다. <br> 
| | send | global | <`settings.ini`> 설정 파일 <br>`luikie@luikie.sm.jj.ac.kr` 계정으로 TO = `lki_familiar@naver.com` 주소로 송부합니다 |
| `oracle` | install | * | Oracle 21c **Preinstall** & <br> **EE 서비스 설치** 및 **DB 생성** |
| | setdb | * | <`settings.ini`> 설정 파일 <br>DB = linuxDB<br>TABLE = final_record<br> **DB 명 변경** 및 **테이블 생성**|
| | back | * | **DB 오류 발생** 시 이전 설정으로 **복구** |
| | sql | * | **`<data.txt>`** 데이터 레코드를 <br>**final_record** 테이블에 자동 삽입<br>|
| | sort | * | **`<data.txt>`** 데이터 레코드를<br>조건에 맞게 정렬 후 <br>**`<score_result.txt>`** 파일로 저장 |

</details>

<br><hr>

# ⚙️ Configuration

## 🏷️ `<settings.ini>` 설정
<details open>
<summary> View </summary>

<hr>

### 1. 사용자 설정
<details>
<summary> View </summary>

```css
[USER DATA]
ID = 15
NICK = luikie
NAME = 이강일
```
| 필드 | 값 | 설명 |
| :---: | :---: | :---: |
|`ID`| 15 |수업번호를 의미합니다.
|`NICK`| luikie |수업별칭을 의미합니다.
|`NAME`| 이강일 |본인의 이름을 의미합니다.
</details>

<hr>

### 2. APM 설정
<details>
<summary> View </summary>

```css
[APM DATA]
FILES = xe.tar.gz
DIRECTORY = xe
```
| 필드 | 값 | 설명 |
| :---: | :---: | :---: |
|`FILES`| xe.tar.gz |웹 소스 파일명
|`DIRECTORY`| xe |압축 해제 후 저장되는 폴더명
</details>

<hr>

### 3. 메일 설정
<details>
<summary> View </summary>

```css
[MAIL DATA]
TO = 이메일 주소
```
| 필드 | 값 | 설명 |
| :---: | :---: | :---: |
|`TO`| 이메일 주소 | 전송할 이메일 주소 입력
</details>

<hr>

### 4. IP 설정
<details>
<summary> View </summary>

```css
[IP DATA]
IP = 본인 자리의 아이피 주소
```
| 필드 | 값 | 설명 |
| :---: | :---: | :---: |
|`IP`| 본인 자리의 아이피 주소 | 시험 자리 아이피 입력
</details>

<hr>

### 5. DB 설정
<details>
<summary> View </summary>

```css
[ORACLE DATA]
DB = linuxDB
TABLE = final_record
```
| 필드 | 값 | 설명 |
| :---: | :---: | :---: |
|`DB`| linuxDB | 변경할 DB 명
|`TABLE`| final_record | 생성 · 삽입할 TABLE 명
</details>

<hr>

### 6. 정렬 알고리즘 설정
<details>
<summary> View </summary>

```css
[SORT DATA]
HEAD = 5
TAIL = 5
TYPE = 1
```
| 필드 | 값 | 설명 |  | 조건 |
| :---: | :---: | :---: | :---: |:---: |
|`HEAD`| 5 | 위부터 아래로 5 라인 설정 ||
|`TAIL`| 5 | 아래부터 위로 5 라인 설정 || 
|`TYPE`| 0 | 정렬 알고리즘 유형 ||자신의 위아래 10개 데이터의 수업번호가 한 가지 조건일 때<br>1~10, 11~20, 21~30, 31~40 해당
|| 1 | 정렬 알고리즘 유형 ||수업번호 01∼10번까지는 학년 순으로 만약 같으면 그룹 순<br>수업번호 11∼20번까지는 이름 순과 만약 같으면 학년 순
|| 2 | 정렬 알고리즘 유형 ||수업번호 11∼20번까지는 이름 순과 만약 같으면 학년 순<br>수업번호 21∼30번까지는 그룹 순과 만약 같으면 학년 순
|| 3 | 정렬 알고리즘 유형 ||수업번호 21∼30번까지는 그룹 순과 만약 같으면 학년 순<br>수업번호 31∼40번까지는 학점 순과 만약 같으면 학년 순
|| 4 | 정렬 알고리즘 유형 ||수업번호 31∼40번까지는 학점 순과 만약 같으면 학년 순<br>수업번호 41∼48번까지는 높은 학년 순과 만약 같으면 그룹 순

`[예시] : 자신의 위 5, 아래 4 10개의 데이터가 8 ~ 17 범위에 포함될 때`<br>
* HEAD  = 3<br>
* TAIL  = 7<br>
* TYPE  = 1 <br>
### 따라서 `[TYPE 1]` 알고리즘으로 8~10 번(HEAD 3), 11~17 번(TAIL 7) 정렬이 가능함
</details>

<hr>

### 7. * **개발자용** * 스크립트 모듈 설정
<details>
<summary> View </summary>

```css
[SCRIPT DATA]
MODULES = settings, repo, apm, quota, mail, oracle, messages
```
| 필드 | 값 | 설명 |
| :---: | :---: | :---: |
|`MODULES`| settings, repo, apm, quota, mail, oracle, messages| 사용자 정의 스크립트 파일을 `./Resource/Scripts/`<br> 경로에 저장 후 추가하여 자동 연결

### * <span style="color: #DA4354">안정성과 호환성을 위하여, 개발자 설정 부분을 최대한 수정하지 않는 것을 권장합니다.</span>
</details>
</details>
</details>


<hr>

# 📃 Guide

## 🏷️ 명령어 가이드
<details open>
<summary> View </summary>
<hr>

### 1. repo 명령어
<details>
<summary> View </summary>

```css
[root@locahost sm-shell]# ./sm_final.sh repo
```
* repo 명령 입력 시 아래와 같은 동작을 수행합니다.
    - /etc/yum.repo.d 에 존재하는 온라인 repo 를 모두 삭제하고, loca.repo 를 복사합니다.
    - 가장 많은 시간이 소요되는 `createrepo` 명령을 수행할 필요가 없어 `10초` 이내에 레포가 설치됩니다.
</details>
<hr>

### 2. rpm 명령어
<details>
<summary> View </summary>

```css
[root@localhost sm-shell]# ./sm_final.sh rpm
-rw-r--r-- 1 root  root  56227  Jun 19  21:27 15-이강일-rpm-list.log
```
* 시스템에 존재하는 패키지 목록을 $ID-$NAME-rpm-list.log 로 저장합니다.
</details>
<hr>

### 3. apm 명령어
<details>
<summary> View </summary>

```css
[root@localhost sm-shell]# ./sm_final.sh apm split
-rw-r--r-- 1 root  root  16589296  Jun 19  21:27 mysql-5.6.24.tar.gz.part-0
-rw-r--r-- 1 root  root  16589296  Jun 19  21:27 mysql-5.6.24.tar.gz.part-1

[root@localhost sm-shell]# ./sm_final.sh apm merge
-rw-r--r-- 1 root  root  33178592  Jun 19  21:27 mysql-5.6.24.tar.gz
```
* split 명령어로 mysql-5.6.24.tar.gz 소스 압축파일을 2개로 분할합니다.
* merge 명령어로 mysql-5.6.24.tar.gz.part0-1 분할 파일을 하나로 병합합니다.
<br><br>

```css
[root@localhost sm-shell]# ./sm_final.sh apm install
... # 설치 및 압축 해제 후
Enter current password for root (enter for none): (엔터)
Change the root password? [Y/n] y
New password: (비밀번호 입력)
Re-enter new password: (비밀번호 재입력)
Remove anonymous users? [Y/n] y
Disallow root login remotely? [Y/n] n
Remove test database and access to it? [Y/n] y
Reload privilege tables now? [Y/n] y

```
* apm `install` 명령 사용 시 아래와 같은 동작이 수행됩니다.
    - Apache(2.4.6) PHP(5.4.16) Mariadb(5.5.68) 및 의존, 종속성 패키지 자동 설치
    - Web 소스 /var/www/html 압축 해제 후 권한 부여
    - DB 연결 후 복구
<br><br>

```css
[root@localhost sm-shell]# ./sm_final.sh apm check
```
* APM 서비스 오류 유무를 확인합니다.
> ℹ️ 서비스 비정상 동작 시에만 오류 메세지 출력
</details>

<hr>

### 4. quota 명령어
<details>
<summary> View </summary>

```css
[root@localhost ~]# mkdir /quotahome
[root@localhost ~]# fdisk -l
[root@localhost ~]# fdisk /dev/sda

Command (m for help): n
Partition type:
   p   primary (3 primary, 0 extended, 1 free)
   e   extended
Select (default e): p
Partition number (3-4, default 3): 3
First sector (10001-209715, default 10001): 10001
Last sector, +sectors or +size{K,M,G} (10000-209715, default 209715): +1G
Partition 3 of type Linux and of size 1 GiB is set
Command (m for help): w

[root@localhost ~]# partprobe -s
[root@localhost ~]# fdisk -l
[root@localhost ~]# mkfs.ext4 /dev/sda3
[root@localhost ~]# mount /dev/sda3 /quotahome
[root@localhost ~]# cd /quotahome
```
* 위와 같이 초기 파티션 설정을 해줍니다.
* 보통 디스크 이름은 HDD : `sda`, SSD : `nvme0n1p` 입니다.
> ℹ️  `fdisk -l` 명령으로 정확한 파티션을 지정해줘야 합니다.

<br><br>

```css
[root@localhost quotahome]# /sm-shell/sm_final.sh quota install
[root@localhost quotahome]# ls -al
.
..
...
drwxr--r-- 1 root  root  33 Jun 19  21:27 csejj
drwxr--r-- 1 root  root  33 Jun 19  21:27 samuel
drwxr--r-- 1 root  root  33 Jun 19  21:27 luikie
drwxr--r-- 1 root  root  0  Jun 19  21:27 lost+found
```
* 초기 파티션 설정 후 명령어를 입력해 사용자 및 그룹을 자동 구성합니다.
* `ls-al` 명령어 실행 결과가 위와 같다면 성공입니다.
* `lost+found` 디렉토리는 ext4 파일 시스템으로 포맷되었다는 것을 의미합니다.
> ℹ️ `lost+found` 디렉토리가 존재하지 않는 경우 마운트 재확인

<br>

```css
[root@localhost quotahome]# /sm-shell/sm_final.sh quota set /dev/sda3
[quotaoff] off /dev/sda3
[quotaon] on /dev/sda3
[quota] completed

[root@localhost quotahome]# mount -o remount /dev/sda3
[root@localhost quotahome]# repquota -au
[root@localhost quotahome]# repquota -ag
```
* `repquota -au` 사용자 quota 확인 명령어
* `repquota -ag` 그룹 quota 확인 명령어
</details>

<hr>

### 5. sendmail 명령어
<details>
<summary> View </summary>

```css
[root@localhost ~]# /sm-shell/sm_final.sh mail install
```
* `mail install` 명령어는 sendmail 및 의존 · 종속 패키지를 설치합니다.
<br><br>

```css
[root@localhost ~]# /sm-shell/sm_final.sh mail send local

[root@localhost ~]# /sm-shell/sm_final.sh mail send global
```
* `mail send local` 명령어는 root@localhost.localdomain 계정으로 전송합니다.
* `mail send global` 명령어는 luikie@luikie.sm.jj.ac.kr 계정으로 전송합니다.
    * TO 에 설정해둔 주소<br><br>
* 미리 설정해둔 이메일 주소로 `score_result.txt` 첨부 메일을 송부합니다.
> ℹ️  메일 첨부 양식
> > <details><summary>View</summary>
> > attachment="/sm-shell/score_result.txt"<br>
> > echo "From: $domain"<br>
> > echo "To: lki_familiar@naver.com, $domain"<br>
> > echo "Subject: $subject"<br>
> > echo "Content-Type: multipart/mixed; boundary=XYZ"<br>
> > echo ""<br>
> > echo "--XYZ"<br>
> > echo "Content-Type: text/plain; charset=utf-8"<br>
> > echo ""<br>
> > echo "$body"<br>
> > echo "--XYZ"<br>
> > echo "Content-Type: text/plain"<br>
> > echo "Content-Disposition: attachment; filename=\"score-result.txt\""<br>
> > echo ""<br>
> > cat "$attachment"<br>
> > echo "--XYZ--"<br>
> > EOF
</details>

<hr>

### 6. Oracle 명령어
<details>
<summary> View </summary>

---
#### 6-1. oracle install
___
```css
[root@localhost home]# /sm-shell/sm_final.sh oracle install
```
* `oracle install` 명령 사용 시 아래와 같은 동작이 수행됩니다
    - Oracle 21c Preinstall, EE 설치
    - /etc/init.d/oracledb_ORCLCDB-21c configure 명령으로 초기 DB 구축
    - oracle 사용자 dba 그룹 추가 후 비밀번호 wjsansrk 설정
    - .bash_profile oracle 홈 디렉토리에 복사
>  ℹ️  설치 및 초기 DB 구성까지 약 10분 소요됩니다.

<br>

___
#### 6-2. oracle setdb (수동 설정)
___
```css
[oracle@localhost home]$ cd ~
[oracle@localhost ~]$ cat .bash_profile | grep "ORACLE_SID"
export ORACLE_SID=ORCLCDB
```
* 명령어 입력 시 export ORACLE_SID=ORCLCDB 가 출력되면 정상입니다.
<br><br>

```css
[oracle@localhost ~]$ source .bash_profile
[oracle@localhost ~]$ ora
SQL> shutdown immediate;
SQL> startup mount;
SQL> exit;
```
* source .bash_profile 명령어로 설정을 적용해줍니다.

* ora 명령어로 db 접속해 위 SQL 명령어 3개를 순차적으로 입력합니다.
<br><br>

```css
[oracle@localhost ~]$ nid target=sys dbname=linuxDB
비밀번호 : wjsansrk
... (생략)
> [Y/N]: y
...Success (생략)
```
* nid 명령어로 ORCLCDB 에서 linuxDB 로 DB 명을 변경합니다.

<details>
    <summary>오류 발생 시 해결 방법</summary>

* ORA-01034 oracle avaliable 오류
    - startup mount;
    - select name from v$database;<br><br>

+ ORA-01109 데이터베이스 개방 오류
	- alter database open;<br><br>

+ NID-00106 오라클 오류와 함께 DB 로그인 실패
	- DB 로그인 실패 오류임. 비번 확인
	- 오라클 startup mount; 가 되어 있지 않아 발생함.<br><br>

+ NID-00121 데이터 베이스 오픈 오류
	- shutdown immediate;<br><br>

+ NID-00135 활성 스레드 오류
	- alter database open;
	- shutdown immediate;
	- startup mount;<br><br>
<hr>
</details>
<br><br>

```css
[oracle@localhost ~]$ sed -i 's/export ORACLE_SID=ORCLCDB/export ORACLE_SID=linuxDB/g' /home/oracle/.bash_profile
[oracle@localhost ~]$ cat .bash_profile | grep "ORACLE_SID"
export ORACLE_SID=linuxDB
[oracle@localhost ~]$ source .bash_profile
[oracle@localhost ~]$ cp -rf /sm-shell/Resource/Data/initlinuxDB.ora /opt/oracle/dbs
```
* sed 명령어로 .bash_profile ORACLE_SID 값을 ORCLCDB -> linuxDB 로 변경합니다.
* cat 명령어로 변경이 잘되었는지 확인합니다.
* 변경이 올바르게 되었다면, source 명령어로 변경된 설정을 적용합니다.
* cp -rf 명령을 수행하여 /opt/oracle/dbs 경로에 initlinuxDB.ora 을 복사합니다.
<br><br>

```css
[oracle@localhost ~]$ ora
SQL> shutdown immediate;
SQL> startup mount;
SQL> select name from v$database;
SQL> alter database open resetlogs;
SQL> exit;
```
* ora 를 입력해 DB 접속 후 아래 SQL 6개 명령을 순차적으로 수행합니다.
* select name from v$database; 명령 입력 시 LINUXDB 명이 출력되면 DB 명 변경 성공입니다.

<br>

___
#### 6-3. oracle back
___
```css
[oracle@localhost home]$ /sm-shell/sm_final.sh oracle back
```
* `oracle setdb` 명령 수행 후 오류 발생 시 초기 상태로 복구해주는 명령어입니다.
<br><br>

___
#### 6-4. oracle sql
___
```css
[oracle@localhost home]$ /sm-shell/sm_final.sh oracle sql
[oracle@localhost home]$ ora
SQL> select * from final_record;
```
* `oracle sql` 명령 사용 시 아래와 같은 동작이 수행됩니다.
    - sql 실행하고 final_record 테이블 생성
    - sqlldr(sql loader) 를 사용하여 `./Resource/Data/score.txt` 데이터 삽입
* 사용자 명 : sys as sysdba
* 비밀번호  : wjsansrk
<br>

___
#### 6-5. oracle sort
___
```css
[oracle@localhost home]$ su
[root@localhost ~]# /sm-shell/sm_final.sh oracle sort
```
* 미리 설정해둔 조건으로 `./Resource/Data/score.txt` 데이터 정렬 후 `./score_result.txt` 파일로 저장합니다.
<br>

___
#### 6-6. oracle sort
___
```css
[root@localhost ~]# ls -al /sm-shell | grep score*
[root@localhost ~]# /sm-shell/sm_final.sh mail send
```
* `ls -al` 명령어로 score_result.txt 파일 존재 유무 확인
* `mail send` 명령어로 미리 설정한 이메일 주소로 첨부 메일 송부

> ℹ️  `'./Resource/Data/settings.ini'`<br> > TO 필드에 설정된 이메일 주소로 전송됩니다.
</details>

</details>
</details>
<br><hr>

# 🤗 Standardization

## 📰 코드 표준화
<details open>
<summary> View </summary>


## 1. Function Renaming (`main`)
<details>
<summary> View </summary>

```bash
# Global _Function > __Function
__Global_Function() {
    ...
} 

# Local _Function > __Function
_Local_Function() {
    ...
} 

```
* 전역 함수는 `Underbar(_) 2개`로 구분합니다.
* 지역 함수는 `Underbar(_) 1개`로 구분합니다.
</details>

---

## 2. Exception & Error Handling (`main`)
<details>
<summary> View </summary>

```bash
# Exception $ Error Send
__Function() {
    ... # 정상 출력
else # 예외 및 오류 발생
    # __Handler:함수호출 $Function:오류함수 $date:발생시간 $Error_Out:오류전달"
    __Handler "$Function" "$date" "$Error_Out"
}

# Exception & Error Handler
__Handler() {
    # 전달 받은 인자 출력
    echo -e "$white""$b_red[$2] $1 $3 Error$cls"
}

```
* 오류 발생 값을 `파라미터`로 `명확하게 전달`하는 구문을 사용합니다.
* 예외 및 오류 처리를 위한 `핸들링 함수`를 추가합니다.
</details>

---

## 3. High Available (`main`)
<details>
<summary> View </summary>

```bash
# Exception & Error Handler
__Handler() {
    # 전달 받은 인자 Error_$date.log Append Logging
    echo "[$2] $1 $3 Error" >> $log_path/Error_"$(date +"%m%d")".log
    echo -e "$white""$b_red[$2] $1 $3 Error$cls"
} 2>> $log_path/Error_"$(date +"%m%d")".log

```
* `2>> ./path/file` Redirection 명령줄로 `성공 | 오류` 표준 입출력을 지정합니다.
* 코드를 효율적으로 관리하기 위하여 각 함수 별로 표준 입출력 및 동작 로그를 저장합니다.
    </details> 

</details>

<br><hr>

# 🔖 Reference
<details>
<summary> View </summary>

## 1. Reference Link

* [[Bash Style 표준화 지침] : 원문본(English)](https://github.com/icy/bash-coding-style)
    * [[Bash Style 표준화 지침] : 번역본(Korean)](https://sepiros.tistory.com/28)

</details>
