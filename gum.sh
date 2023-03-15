#!/bin/bash
# Made by luikie

# Check arr txt file
if [[ ! -f "./sm-user.txt" ]]
then
	wget "https://raw.githubusercontent.com/Memori-al/bash-scripts/main/sm-user.txt"
	
fi
if [[ ! -f "./sm-deluser.txt" ]]
then
	echo > ./sm-deluser.txt
fi

# Variable
title="[Console]"
uid_arr=(`cat ./sm-user.txt`)
duid_arr=(`cat ./sm-deluser.txt`)

# Main Function
main() {
	clear
	echo U s e r G r o u p M a n a g e r
	echo
    echo "[1] Useradd to Group"
    echo "[2] Delete users from group"
    echo "[0] Exit"
	echo
	echo -n "$title Select Menu: "
    read key

    if [ ${key} -eq 1 ] ; then
        utg
    elif [ ${key} -eq 2 ] ; then
        dfg
    elif [ ${key} -eq 0 ] ; then
        exit 0
    else
        error 1
    fi
}

# Add non-existent users to the group
utg() {
	if [ ${#uid_arr[@]} -eq 0 ]; then
        error "Unable to read user list"
    fi
	
	count=0
    echo -n "$title Group Name: "
    read group_name
	echo -n "$title User Passwd: "
    read user_passwd
    for i in ${uid_arr[*]}
    do
		if getent group "$group_name" | grep &>/dev/null "\b$i\b"; then
			echo "User $i already exists in group $group_name"
		else
			count=$(($count+1))
			if id -u "$i" >/dev/null 2>&1; then
				usermod -a -G "$group_name" "$i"
				echo "$title User $i Go to SM Group"
			else
				useradd -m -d /home/$i -s /bin/bash $i
				echo "$i:$user_passwd"|chpasswd
				usermod -aG $group_name $i
				echo "$title Create $i user and move to SM group"
			fi
		
		fi
    done
    echo "$title $count Created!"
	sleep 3
    main
}

# Delete users in a group
dfg() {
	if [ ${#duid_arr[@]} -eq 0 ]; then
        error "Unable to read user list"
    fi
	count=0
    echo -n "$title Group Name: "
    read group_name
	for d in ${duid_arr[*]}
		do
		if getent group "$group_name" | grep &>/dev/null "\b$d\b"; then
			userdel -r $d
			echo "User $d deleted from $group_name"
			count=$(($count+1))
		else
			echo "User $d does not exist in the group."
		fi
	done
	echo "$title $count Deleted!"
	sleep 3
    main
}

# error exception
error() {
    echo "$title ERROR: $1"
    sleep 3
    main
}

# Call Main Function
main