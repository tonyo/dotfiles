# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

export EDITOR=/usr/bin/vim

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions
test -s ~/.alias && . ~/.alias || true

#############
# PATH update 

# Delete '.' from PATH and add 'sbin'
PATH=`echo $PATH | sed 's/:\.:/:/g; s/:\.$//g; s/\.://g'`
PATH=$PATH:/usr/sbin:/sbin

# Local bin
PATH=$PATH:~/bin:~/.local/bin
export PATH

##############
# color prompt
function prompt_command {

    local PWDNAME=$PWD

    # beautify working directory name
    if [[ "${HOME}" == "${PWD}" ]]; then
        PWDNAME="~"
    elif [[ "${HOME}" == "${PWD:0:${#HOME}}" ]]; then
        PWDNAME="~${PWD:${#HOME}}"
    fi

    local PS1_DIR="\[\e[1;31m\][\u@\h: \w]\[\e[0m\]"
    local PS1_ENDL="\n"
    local PS1_GO="\[\e[1;31m\]$\[\e[0m\] "
    local PS1_DIR_LEN=$((${#USER}+${#HOSTNAME}+${#PWDNAME}+5))

    COLS=$(tput cols)
    local fillsize=$(($COLS-$PS1_DIR_LEN-1))
    local FILL=" "
    while [[ $fillsize -gt 0 ]]; do FILL="${FILL}─"; fillsize=$(($fillsize-1)); done

    ### With fill:
    # export PS1=${PS1_DIR}${FILL}${PS1_ENDL}${PS1_GO}

    ### With time:
    local TIME=" ($(date +'%H:%M:%S'))"
    export PS1=${PS1_DIR}${TIME}${PS1_ENDL}${PS1_GO}
}

PROMPT_COMMAND=prompt_command

# git aliases
alias gitst='git status'
alias gitf='git fetch'
alias gitd='git diff'
alias gitl='git log'

# tmux aliases
alias tm='tmux'

# apt-get & yum update-upgrade
alias aptupup='sudo apt-get update && sudo apt-get upgrade -y'
alias yup='echo "sudo yum update" && sudo yum update'

# system aliases
alias varlog='M="sudo tail -f /var/log/messages";echo $M; eval $M;'

# kde-open: open file via its default application
alias op='kde-open'

# smart cp
alias cps='rsync --progress'

# load useful functions
source .bashrc_functions

