<hr>

# <span style="color: #50bcdf">Overview</span>
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

# <span style="color: #ffd700">Contents</span>
## 📖 Theory
* [아키텍처](#architecture)
    * [도식도](#-architecture-diagram)

## ⚙️ Technique
* [기능 및 명령어](#features--commands)
    * [명령어 표](#Command-and-parameters($))

## 🌱 Configuration
* [settings.sh 초기 설정 방법](#Configuration)
    * [사용자 설정](#1-사용자-설정)
    * [APM 설정](#2-APM-설정)
    * [메일 설정](#3-메일-설정)
    * [IP 설정](#4-IP-설정)
    * [DB 설정](#5-DB-설정)
    * [정렬 알고리즘](#6-정렬-알고리즘-설정)
    * [(*개발자용) 스크립트 모듈 설정](#7--개발자용--스크립트-모듈-설정)

## 🤗 Standardization
* [표준화](#Features-&-Commands)
    * [Function Renaming](#1-Function-Renaming-main)
    * [Exception & Error Handling](#2-Exception--Error-Handling-main)
    * [HA Logging](#3-HA-Logging-main)

## 🔖 Reference
* [Reference Link](#reference)
   * [Bash Style 표준화 지침서](#1.-reference-link)

<hr>

# <span style="color: #50bcdf">Architecture</span>
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

# <span style="color: #50bcdf">Features & Commands</span>
## 🏷️ Table
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
| | send | * | <`settings.ini`> 설정 파일 <br>TO = lki_familiar@naver.com <br> 메일 송부 |
| `oracle` | install | * | Oracle 21c **Preinstall** & <br> **EE 서비스 설치** 및 **DB 생성** |
| | setdb | * | <`settings.ini`> 설정 파일 <br>DB = linuxDB<br>TABLE = final_record<br> **DB 명 변경** 및 **테이블 생성**|
| | back | * | **DB 오류 발생** 시 이전 설정으로 **복구** |
| | sql | * | **`<data.txt>`** 데이터 레코드를 <br>**final_record** 테이블에 자동 삽입<br>|
| | sort | * | **`<data.txt>`** 데이터 레코드를<br>조건에 맞게 정렬 후 <br>**`<score_result.txt>`** 파일로 저장 |

</details>

<br>

## 🏷️ Command
<details>
<summary> View </summary>
<hr>

### 1. repo 명령어

```css
[root@locahost sm-shell]# ./sm_final.sh repo
```
* /etc/yum.repo.d 에 존재하는 온라인 repo 를 모두 삭제하고, loca.repo 를 복사합니다.

* 가장 많은 시간이 소요되는 `createrepo` 명령을 수행할 필요가 없어 `10초` 이내에 레포가 설치됩니다.

<hr>

### 2. rpm 명령어

```css
[root@localhost sm-shell]# ./sm_final.sh rpm
-rw-r--r-- 1 root  root  56227  Jun 19  21:27 15-이강일-rpm-list.log
```
* 시스템에 존재하는 패키지 목록을 $ID-$NAME-rpm-list.log 로 저장합니다.

<hr>

### 3. apm 명령어

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
* Apache(2.4.6) PHP(5.4.16) Mariadb(5.5.68) 및 의존, 종속성 패키지 자동 설치
* Web 소스 /var/www/html 압축 해제
* DB 연결 후 복구
<br><br>

```css
[root@localhost sm-shell]# ./sm_final.sh apm check
```
* APM 서비스 오류 유무를 확인합니다.
> 서비스 정상 시 아무 메세지도 출력되지 않습니다.

<br><br>
<hr>

### 4. quota 명령어

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
[root@localhost quotahome]# /sm-shell/sm_final.sh quota install
```
* 시스템에 존재하는 rpm list 를 $ID-$NAME-rpm-list.log 로 저장합니다.
<br><br>

```css
[root@localhost quotahome]# /sm-shell/sm_final.sh quota set /dev/sda3

[root@localhost quotahome]# mount -o remount /dev/sda3
[root@localhost quotahome]# repquota -au
[root@localhost quotahome]# repquota -ag
```
* `repquota -au` 사용자 quota 확인 명령어
* `repquota -ag` 그룹 quota 확인 명령어
</details>
<br><hr>

# <span style="color: #50bcdf">Configuration</span>

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

<br>
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

<br>
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

<br>
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

<br>
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

<br>
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

<br>

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


<br><hr>

# <span style="color: #50bcdf">Standardization</span>

<details open>
<summary> View </summary>
<br>

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

<br>

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

<br>

## 3. HA Logging (`main`)
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

# <span style="color: #50bcdf">Reference</span>
<details>
<summary> View </summary>

## 1. Reference Link

* [[Bash Style 표준화 지침] : 원문본(English)](https://github.com/icy/bash-coding-style)
    * [[Bash Style 표준화 지침] : 번역본(Korean)](https://sepiros.tistory.com/28)

</details>
