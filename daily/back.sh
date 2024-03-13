#!/bin/bash


function _Init() {
    if [[ -f "./setting.ini" ]]; then
        _variables=("log")

        for _var in "${_variables[@]}"; do
            _value=$(grep "$_var =" "./setting.ini" | cut -f2 -d "=")
            _value=$(echo "$_value" | sed 's/ //g')
            declare "_$var"_"=$_value"
        done
    else
        _Handler "0" "$(date +"%H:%M:%S")" "setting.ini"
    fi
    if [[ -f "./color.sh"]]; then
        source ./color.sh
    else
        _Handler "0" "$(date +"%H:%M:%S")" "color.sh"
    fi
    _Check
}


function _Check() {
    if [[  ]]; then

    fi
}


function _Handler() {
	case $1 in
		0)
			_exception_type_="alert"
			_exception_message_="$3: file dosen't exist."
		;;
		1)
			_exception_type_="warning"
			_exception_message_="[$2|${magenta}warning${cls}|$USER|$_client_ip_]	'$3' command execution.	[$_try_]"
		;;
		2)
			_exception_type_="critical"
			_exception_message_="[$2|${red}critical${cls}|$USER|$_client_ip_]	'$3' command execution.	[$_try_]"
		;;
	esac
	
	
	
	if [[ "$_exception_type_" == "Alert" ]]; then
		echo -e "$_exception_message_"
	else # Warning & Error Logging
		echo "${_exception_message_}" | tee -a /var/log/rsm_$(date +"%y%m%d").log > /dev/null
		echo -e "${red}You do not have permission to execute the command.${cls}"
	fi
}


_Init