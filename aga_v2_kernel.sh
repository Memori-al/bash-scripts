#!/bin/bash
# Made by luikie #
# Commit Date : 2023. 03. 22. Web #

Main() {
	# sm-*.txt 파일 확인
	if [[ ! -f "./sm-user.txt" ]]; then
		wget "https://raw.githubusercontent.com/Memori-al/bash-scripts/main/sm-user.txt" # git 서버에서 sm-user.txt 파일 다운로드
	fi
	if [[ ! -f "./sm-deluser.txt" ]]; then
		wget -O "./sm-deluser.txt" "https://raw.githubusercontent.com/Memori-al/bash-scripts/main/sm-user.txt" # git 서버에서 sm-user.txt 파일 다운로드 후 sm-deluser.txt 로 저장
	fi
	# 변수 설정
	title="[Console]"
	red="\e[91m"
	white="\e[97m"
	green="\e[92m"
	blue="\e[94m"
	tear="\e[96m"
	yellow="\e[93m"
	magenta="\e[95m"
	cyan="\e[0;96m"
	cls="\e[m" # 색상 초기화
	Menu # Menu 함수 호출
}

# Menu Function
Menu() {
	count=0 
	clear
	echo -e "[${blue}U S E R G R O U P A U T O G E N E R A T O R S${cls}]"
	echo
    echo -e "[${green}1${cls}] Useradd to Group"
    echo -e "[${cyan}2${cls}] Delete users from group"
	echo -e "[${magenta}3${cls}] 5000 Useradd to Group"
	echo -e "[${magenta}4${cls}] Delete 5000 users from group"
    echo -e "[${red}0${cls}] Exit"
	echo
	echo -e -n "$title ${tear}Select Menu:${cls} "
    read key
    if [ ${key} -eq 1 ] ; then
        Utg
    elif [ ${key} -eq 2 ] ; then
        Dfg
	elif [ ${key} -eq 3 ] ; then
        Ua5
	elif [ ${key} -eq 4 ] ; then
        Ud5
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
		if ! getent group "$gname" | grep &>/dev/null "\b$gid\b"; then # 그룹이 존재하지 않을 때
			groupadd -g $gid $gname # 그룹 ID 인 그룹 생성
			echo "$title Created group $gname with group ID $gid." # 생성 후 결과 보고
		fi
	done

	# Utg
	while read -r user group # sm-user.txt 데이터를 읽어옴
	do
		if getent group "$group" | grep &>/dev/null "\b$user\b"; then # 그룹에 사용자가 존재할 때
			echo -e "$title ${red}User $user already exists in group $group.${cls}"
		else
			if id -u "$user" >/dev/null 2>&1; then # 사용자가 시스템 상에 존재할 때
				usermod -a -G "$group" "$user" # 그룹에 사용자 추가
				chgrp "$group" "/home/$user" # 그룹에 사용자 추가
			else
				useradd -m -d /home/$user -s /bin/bash $user # 사용자와 사용자의 home 디렉토리 생성
				echo "$user:wjsansrk"|chpasswd # 사용자의 비밀번호 변경
				usermod -a -G "$group" "$user"  # 그룹에 사용자 추가
				chgrp "$group" "/home/$user" # 그룹에 사용자 추가
				echo "$title Create $user and move to $group group" # 생성 후 결과 보고
			fi
			count=$(($count+1))
		fi
	done < sm-user.txt
	echo "$title $count Created!"
	read -t 3 -s
    Menu
}

# Delete users in a group
Dfg() {
	if [ ! -s "sm-deluser.txt" ]; then # sm-deluser.txt 데이터가 비었을 때 예외 처리
        Error "$title Unable to read user list. please check ./sm-deluser.txt"
    fi
	
	while read -r user group # 데이터를 읽어와 f1, f2 필드에 user group 각각 저장
	do
		if getent group "$group" | grep &>/dev/null "\b$d\b"; then # 그룹에 사용자가 존재할 때
			userdel -r $user
			echo "$title User $user deleted from $group"
			count=$(($count+1))
		else
			echo "$title ${red}User $user does not exist in the group.${cls}"
		fi
	done < sm-deluser.txt
	echo "$title $count Deleted!"
	read -t 3 -s
    Menu
}

Ua5() {
	echo -n "$title Please specify a group name: "
	read group
	if grep -q "^$group:" /etc/group; then # 그룹이 시스템에 존재할 때
		echo -n "$title $group group already exists. Are you sure you want to select it to that group?(y/n): " # 해당 그룹으로 진행할 지 출력
		read Fkey
		if [[ ${Fkey} == "n" ]]; then # n 값 입력 시 add5000 함수로 다시 돌아감
			Ua5
		elif [[ ${Fkey} == "y" ]]; then # y 값 입력 시 출력 후 진행
			echo "$title Selected $group group"
		else # y, n 값이 아닐 때 예외 처리
			Error "$title key input Error!"
		fi
	fi
	if ! grep -q "^$group:" /etc/group; then # 그룹이 시스템에 존재하지 않을 때
		echo -n "$title $group group does not exist. Do you want to create that group?(y/n): " #그룹이 시스템에 존재하지 않아 그룹을 생성할지 출력
		read Fkey
		if [[ ${Fkey} == "n" ]]; then # n 값 입력 시 재귀
			Ua5
		elif [[ ${Fkey} == "y" ]]; then # y 값 입력 시 진행
			groupadd $group
			echo "$title $group add"
		else # y, n 값이 아닐 때 예외 처리
			Error "$title key input Error!"
		fi
	fi 
	echo -n "$title Please specify a user name: "
	read user
	if [ ! -d "/home2" ]; then # home2 디렉토리가 존재하지 않을 때
		mkdir /home2 # home2 디렉토리 생성
	fi
	for i in {1..5000}
	do
		if getent group "$group" | grep &>/dev/null "\b$user-$i\b"; then # 그룹에 사용자가 존재할 때
			echo "$title User $user-$i already exists in group $group."
		else # 그룹에 사용자가 존재하지 않을 때
			if id -u "$user-$i" >/dev/null 2>&1; then # 사용자가 시스템 상에 존재할 때
				usermod -a -G "$group" "$user-$i" # 그룹에 사용자 추가
				chgrp "$group" "/home2/$user-$i" # 사용자 디렉토리 권한 그룹으로 변경
			else
				useradd -m -d /home/$user-$i -s /bin/bash $user-$i # 사용자와 사용자의 home 디렉토리 생성
				echo "$user-$i:wjsansrk"|chpasswd # 사용자의 비밀번호 변경
				usermod -a -G "$group" "$user-$i" # 그룹에 사용자 추가
				chgrp "$group" "/home2/$user-$i" # 사용자 디렉토리 권한 그룹으로 변경
				echo "$title Create $user-$i and move to $group group" # 생성 후 결과 보고
			fi
		fi
		count=$(($i+1))
	done
	Menu
}

Ud5() {
	echo -n "$title Please specify the name of the group to delete: "
	read group
	if ! grep -q "^$group:" /etc/group; then # 그룹이 시스템에 존재하지 않을 때
		"$title $group group does not exist."
		read -t 3 -s
		Menu
	fi
	
	Ud5_array=($(getent group $group | cut -d: -f4 | tr ',' ' ')) # getent group 명령어로 group 내 사용자 배열에 저장
	U_count=${#Ud5_array[*]} # 그룹 내 사용자 수 변수에 저장
	if [[ $U_count -eq 0 ]]; then # 그룹 내에 사용자가 존재하지 않을 때
		echo "$title There are no users in the $group group."
		read -t 3 -s
		Menu
	else # 그룹 내에 사용자가 존재할 때
		echo "$title ${#Ud5_array[*]} users in $group group"
		for user in ${Ud5_array[*]}
		do
			userdel -r "$user" # 사용자 삭제
			echo "$title user $user deleted."
		done
	fi
	Menu
}

# error exception
Error() { # 에러 예외 처리 함수
    echo "$title ERROR: $1"
    read -t 3 -s
    Menu
}

# Call Main Function
Main # Main 함수 호출