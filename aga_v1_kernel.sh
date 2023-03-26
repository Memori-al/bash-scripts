#!/bin/bash
# Made by luikie #
# Commit Date : 2023. 03. 15. Wed #

Main() {
	# Check arr txt file
	if [[ ! -f "./sm-user.txt" ]]; then
		wget "https://raw.githubusercontent.com/Memori-al/bash-scripts/main/sm-user.txt" # git 서버에서 sm-user.txt 파일 다운로드
	fi
	if [[ ! -f "./sm-deluser.txt" ]]; then
		echo > ./sm-deluser.txt # 폴더에 파일이 존재하지 않을 때 생성
	fi

	# Variable settings
	title="[Console]"
	red="\e[91m"
	white="\e[97m"
	green="\e[92m"
	blue="\e[94m"
	tear="\e[96m"
	yellow="\e[93m"
	magenta="\e[95m"
	cyan="\e[0;96m"
	cls="\e[m"
	Menu
}

# Menu Function
Menu() {
	clear
	echo -e "[${blue}U S E R G R O U P A U T O G E N E R A T O R S${cls}]"
	echo
    echo -e "[${green}1${cls}] Useradd to Group"
    echo -e "[${cyan}2${cls}] Delete users from group"
    echo -e "[${red}0${cls}] Exit"
	echo
	echo -e -n "$title ${tear}Select Menu:${cls} "
    read key
    if [ ${key} -eq 1 ] ; then
        Utg
    elif [ ${key} -eq 2 ] ; then
        Dfg
    elif [ ${key} -eq 0 ] ; then
        exit 0
    else
        Error 1
    fi
}

# Add non-existent users to the group
Utg() {
	if [ ! -s "sm-user.txt" ]; then # uid_arr 데이터가 비었을 때 예외 처리
        Error "$title Unable to read user list. please check ./sm-user.txt"
    fi
	
	# Group Settings
	groups=("kt:6000" "skt:6001" "lgt:6002") # 그룹:그룹아이디 배열
	for group in "${groups[@]}" # group 변수에 groups 배열 입력
	do
		gname=$(echo $group | cut -d: -f1) # group 배열의 1번 필드 분할 후 저장
		gid=$(echo $group | cut -d: -f2) # group 배열의 2번 필드 분할 후 저장
		if ! getent group "$gname" | grep &>/dev/null "\b$gid\b"; then # 그룹이 시스템 상에 존재하지 않을 때
			groupadd -g $gid $gname # 그룹 ID 인 그룹 생성
			echo "$title Created group $gname with group ID $gid." # 생성 후 결과 보고
		fi
	done
	count=0
	
	# Utg
	while read -r user group # $uid_arr 데이터를 읽어옴
	do
		if getent group "$group" | grep &>/dev/null "\b$user\b"; then # 그룹에 사용자가 존재할 때
			echo "$title User $user already exists in group $group."
		else
			if id -u "$user" >/dev/null 2>&1; then # 사용자가 시스템 상에 존재할 때
				usermod -a -G "$group" "$user" # 그룹에 사용자 추가
			else
				useradd -m -d /home/$user -s /bin/bash $user # 사용자와 사용자의 home 디렉토리 생성
				echo "$user:wjsansrk"|chpasswd # 사용자의 비밀번호 변경
				usermod -a -G "$group" "$user"  # 그룹에 사용자 추가
				echo "$title Create $user and move to $group group" # 생성 후 결과 보고
			fi
			count=$(($count+1))
		fi
	done < sm-user.txt
	echo "$title $count Created!"
	sleep 3
    Menu
}

# Delete users in a group
Dfg() {
	if [ ! -s "sm-deluser.txt" ]; then # uid_arr 데이터가 비었을 때 예외 처리
        Error "$title 제Unable to read user list. please check ./sm-deluser.txt"
    fi
	
	count=0
	while read -r user group # $duid_arr 데이터를 읽어와 f1, f2 필드에 user group 각각 저장
	do
		if getent group "$group" | grep &>/dev/null "\b$d\b"; then
			userdel -r $user
			echo "$title User $user deleted from $group"
			count=$(($count+1))
		else
			echo "$title User $user does not exist in the group."
		fi
	done < sm-deluser.txt
	echo "$title $count Deleted!"
	sleep 3
    Menu
}

# error exception
Error() {
    echo "$title ERROR: $1"
    sleep 3
    Menu
}

# Call Main Function
Main