# Check for an interactive session
[ -z "$PS1" ] && return

#No core dumps
ulimit -S -c 0

#Notify background completion
set -o notify

#Prompt
PS1="\[\033[0;33m\][\u\[\033[0;31m\]@\[\033[0;32m\]\h \[\033[0;34m\]\W]$\[\033[0;37m\]"

#History
shopt -s histappend
export HISTFILESIZE=20000
export HISTSIZE=5000

#Variables
export EDITOR="vim"
export BROWSER="firefox"

#Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias orphan='sudo pacman -Qdt'
alias gitkey='eval `ssh-agent -s` && ssh-add /home/gcool/.ssh/github'
alias gitupdate='sh /home/gcool/scripts/github.sh'
alias pacman='sudo pacman-color'

#GitHub tab completion
source /usr/share/git/completion/git-completion.bash

#Functions

#Create archive
compress () {
    if [ -n "$1" ] ; then
        FILE=$1
        case $FILE in
        *.tar)      shift && tar cf $FILE $* ;;
        *.tar.bz2)  shift && tar cjf $FILE $* ;;
        *.tar.gz)   shift && tar czf $FILE $* ;;
        *.tgz)      shift && tar czf $FILE $* ;;
        *.zip)      shift && zip $FILE $* ;;
        *.rar)      shift && rar $FILE $* ;;
        esac
    else
        echo "usage: compress <archive.tar.gz> <archive> <files>"
    fi
}

#Unpack archive
unpack() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjf $1    ;;
            *.tbz2)     tar xjf $1    ;;
            *.tar.gz)   tar xzf $1    ;;
            *.tgz)      tar xzf $1    ;;
            *.bz2)      bunzip2 $1    ;;
            *.rar)      unrar x $1    ;;
            *.gz)       gunzip $1     ;;
            *.tar)      tar xf $1     ;;
            *.zip)      unzip $1      ;;
            *.Z)        uncompress $1 ;;
            *.7z)       7z x $1       ;;
            *) echo -e ${YELLOW}"'$1' cannot be unpacked"${RESET} ;;
        esac
    else
        echo -e ${YELLOW}"'$1' is an invalid file"${RESET}
    fi
}

#Generate random password
genpasswd() {
	local l=$1
       	[ "$l" == "" ] && l=16
      	tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

#Fix permissions
permfix() {
    for dir in "$@"; do
        find "$dir" -type d -exec chmod 755 {} \;
        find "$dir" -type f -exec chmod 644 {} \;
    done
}
