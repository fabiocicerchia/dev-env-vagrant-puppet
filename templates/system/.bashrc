################################################################################
# ENVIRONMENT VARIABLES
################################################################################
export NSS_SSL_CBC_RANDOM_IV=0
export EDITOR='vim'
export SVN_EDITOR='vim'
export HISTCONTROL='ignoreboth'
export HISTFILESIZE=999999
export HISTSIZE=999999
export HISTTIMEFORMAT="%h/%d -- %H:%M:%S "
export APPLICATION_ENV=development
export PS1='${debian_chroot:+($debian_chroot)}[\[\033[0;37m\]\t\[\033[00m\]] \[\033[0;94m\]\u\[\033[00m\] is `if [ \$? = 0 ]; then echo -e "\[\033[32m\]happy\[\033[00m\]"; else echo -e "\[\033[31m\]sad\[\033[00m\]"; fi` in \[\033[0;36m\]\w\[\033[00m\] \$ '

################################################################################
# OTHER SETTINGS
################################################################################
bind 'set completion-ignore-case on'

# http://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s cdspell
shopt -s checkwinsize
shopt -s dirspell
shopt -s dotglob
shopt -s extglob

#set -o correct
#set -o extendedglob
#set -o autopushd pushdminus pushdsilent pushdtohome
#set -o no_clobber           # don't overwrite files when redirect
#set -o share_history
#set -o hist_verify          # verify when using !
#set -o nohup                # don't kill bg jobs when tty quits
#set -o nocheckjobs          # don't complain about background jobs on exit
#set -o printexitvalue       # print exit value from jobs

#unsetopt bgnice             # don't nice bg command

################################################################################
# ALIASES
################################################################################
alias sl='ls'
alias json='python -mjson.tool'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias sublime='~/Sublime\ Text\ 2/sublime_text'

################################################################################
# CUSTOM FUNCTIONS
################################################################################
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1    ;;
             *.tar.gz)    tar xzf $1    ;;
             *.bz2)       bunzip2 $1    ;;
             *.rar)       rar x $1      ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1     ;;
             *.tbz2)      tar xjf $1    ;;
             *.tgz)       tar xzf $1    ;;
             *.zip)       unzip $1      ;;
             *.Z)         uncompress $1 ;;
             *.7z)        7z x $1       ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function bak() {
    cp $1 $1_$(date +%H:%M:%S_%d-%m-%Y)
}

function swap() {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}
