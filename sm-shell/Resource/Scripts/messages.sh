#!/bin/bash
title="$italic$black$b_yellow Usage $cls"
usage="$white$b_blue command $b_gray$blue$bold"" $1 $cls"

echo # 공통 개행 처리 구문
if [[ "$1" == "oracle" ]]; then
    echo -e "$usage {install|setdb|sorting}"
    echo -e $blue$bold"install$cls  : oracle preinstall & 21c ee install"
    echo -e $blue$bold"setdb$cls    : db name change"
    echo -e $blue$bold"back$cls     : db reverting to before setting"
    echo -e $blue$bold"sql$cls      : table record insertion"
    echo -e $blue$bold"sort$cls     : db data sorting"
elif [[ "$1" == "apm" ]]; then
    echo -e "$usage {install|split|merge|check}"
    echo -e $blue$bold"install$cls  : Apache, Php, Mysql Install"
    echo -e $blue$bold"split$cls    : Mysql.tar.gz split part 2"
    echo -e $blue$bold"merge$cls    : Mysql.part1-2.tar.gz Merge"
    echo -e $blue$bold"check$cls    : APM Service Check"
elif [[ "$1" == "mail" ]]; then
    echo -e "$usage {install|send}"
    echo -e $blue$bold"install$cls  : sendmail install & composition"
    echo -e $blue$bold"send$cls     : Send to score_result.txt file"
elif [[ "$1" == "help" ]]; then
    echo -e "$usage {rpm|repo|apm|oracle|quota|mail}"
    echo -e $blue$bold"rpm$cls       : rpm -qa list output"
    echo -e $blue$bold"repo$cls      : local repository composition"
    echo -e $blue$bold"apm$cls       : Apache, Php, Mysql Install"
    echo -e $blue$bold"oracle$cls    : oracle install"
    echo -e $blue$bold"quota$cls     : quota install & composition"
    echo -e $blue$bold"mail$cls      : Install & Send mail"
elif [[ "$1" == "quota" ]]; then
    echo -e "$usage {install|set}"
    echo -e $blue$bold"install$cls      : quota install"
    echo -e $blue$bold"set$cls          : quota options setting"
else
    echo -e "$title : $shell_path/$(basename $0) $tear'$1'$cls is available command."
    echo  
    echo -e "$usage {rpm|repo|apm|oracle|quota|mail}"
    echo -e $blue$bold"rpm$cls       : rpm -qa list output"
    echo -e $blue$bold"repo$cls      : local repository composition"
    echo -e $blue$bold"apm$cls       : Apache, Php, Mysql Install"
    echo -e $blue$bold"oracle$cls    : oracle install"
    echo -e $blue$bold"quota$cls     : quota install & composition"
    echo -e $blue$bold"mail$cls      : Install & Send mail"
fi
echo   # 공통 개행 처리 구문