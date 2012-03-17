# Check for an interactive session
[ -z "$PS1" ] && return

#Prompt
PS1="\[\033[0;33m\][\u\[\033[0;31m\]@\[\033[0;32m\]\h \[\033[0;34m\]\W]$\[\033[0;37m\]"

#History
export HISTFILESIZE=20000
export HISTSIZE=5000

#Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
