#!/bin/bash

# DB Sorting 후 Score-result.txt 첨부 메일 송부
_Send() {
    domain="$NICK@$NICK.sm.jj.ac.kr"
    subject="$ID-$NAME-리눅스-6번-문제"
    body=$(cat <<-EOT
        $NAME 메일 송부 드립니다.
        한 학기 동안 감사했습니다!
        (별첨) score-result.txt
EOT
)
    attachment="/sm-shell/score_result.txt"

    echo "From: $domain"
    echo "To: lki_familiar@naver.com, $domain"
    echo "Subject: $subject"
    echo "Content-Type: multipart/mixed; boundary=XYZ"
    echo ""
    echo "--XYZ"
    echo "Content-Type: text/plain; charset=utf-8"
    echo ""
    echo "$body"
    echo "--XYZ"
    echo "Content-Type: text/plain"
    echo "Content-Disposition: attachment; filename=\"score-result.txt\""
    echo ""
    cat "$attachment"
    echo "--XYZ--"
}

_Minstall() {
    if [[ ! $(rpm -qa | grep sendmail) ]]; then
        yum install -y sendmail*
    fi
}

# 전달된 파라미터 필터링
if [[ "$1" == "send" ]]; then
    if [[ $(systemctl is-active sendmail) ]]; then
        _Send | /usr/sbin/sendmail -t
        echo 
        echo -e "$white$b_green"" Complete $cls  Mail transfer to "$line"$TO$cls"
        echo 
    else
        _Handler sendmail "$(date '+%H:%M:%S')" service
    fi
elif [[ "$1" == "install" ]]; then
    _Minstall
else
    source $shell_path/messages.sh send
fi