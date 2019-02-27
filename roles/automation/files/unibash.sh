[ -z "$PS1" ] && return

export http_proxy=http://proxy-internet:8080
export https_proxy=http://proxy-internet:8080

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

if [ $(id -u) -eq 0 ];
then # red prompt for root
    PS1="\[\e[0;31m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\\$ "
else # green prompt for non root user
    PS1="\[\e[0;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\\$ "
fi
