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
* [아키텍처](#Architecture)
    * [도식도](#Scripts-Work-low)

## ⚙️ Technique
* [기능 및 명령어](#Features-&-Commands)
    * [명령어 표](#Command-and-parameters($))

## 🌱 Initial Setup
* [`settings.sh` 초기 설정 방법](#Features-&-Commands)
    * [사용자 설정](#Command-and-parameters($))
    * [APM 설정](#Command-and-parameters($))
    * [메일 설정](#Command-and-parameters($))
    * [아이피 설정](#Command-and-parameters($))
    * [DB 설정](#Command-and-parameters($))
    * [정렬 알고리즘](#Command-and-parameters($))
    * [(*개발자용) 스크립트 모듈 설정](#Command-and-parameters($))

## 🤗 Standardization
* [표준화](#Features-&-Commands)
    * [sm_final.sh](#Command-and-parameters($))
    * [repo.sh](#Command-and-parameters($))
    * [apm.sh](#Command-and-parameters($))
    * [quota.sh](#Command-and-parameters($))
    * [mail.sh](#Command-and-parameters($))
    * [oracle.sh](#Command-and-parameters($))

## 🔖 Reference
* [Reference Link](#Features-&-Commands)
   * [Bash Style 표준화 지침서](#1.-Reference-Link)

<hr>

# <span style="color: #50bcdf">Architecture</span>
<details>
<summary> View </summary>

## · Architecture Diagram 

AA :

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```
</details>

<br><hr>

# <span style="color: #50bcdf">Features & Commands</span>
<details>
<summary> View </summary>

## `Command` and `parameters($)`

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

<br><hr>

# <span style="color: #50bcdf">Initial Setup</span>

## 🏷️ `<settings.ini>` 설정
<details>
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

<details>
<summary> View </summary>

### 참고 자료를 활용한 코드 표준화 작업

## 1. sm_final.sh (`main`)
```sh
   echo a
```
</details>

<br><hr>

# <span style="color: #50bcdf">Reference</span>
<details>
<summary> View </summary>

## 1. Reference Link

* [[Bash Style 표준화 지침] : 원문본(English)](https://github.com/icy/bash-coding-style)
    * [[Bash Style 표준화 지침] : 번역본(Korean)](https://sepiros.tistory.com/28)

</details>
