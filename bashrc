alias ls='ls -lFGh --color'
alias mv="mv -i"
alias sshtop="ssh topic@dev.topicdesign.com"
alias apache="sudo /etc/init.d/apache2"
alias o="gnome-open"
export EDITOR=/usr/bin/vi

# command prompt
#export PS1="\[\e[32;1m\]\u@\[\e[32;1m\]\h \[\e[33;1m\]\W> \[\e[0m\]"
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\> "

##################################################
#                   Bash Alias                   #
##################################################
alias ls='ls -GFh --color'
alias sl='ls -GFh --color'
alias l='ls -GFh --color'
alias ll='ls -ltrh --color'
alias la='ls -lrtha --color'
alias al='ls -lrtha--color'
alias hs='history | grep $1'
