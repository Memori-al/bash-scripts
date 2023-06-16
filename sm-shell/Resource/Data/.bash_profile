# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
export TMP=/tmp;
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/21c/dbhome_1
export ORACLE_SID=ORCLCDB
export PATH=$PATH:$ORACLE_HOME/bin
export NLS_LANG=KOREAN_KOREA.AL32UTF8 
alias ora='sqlplus / as sysdba'