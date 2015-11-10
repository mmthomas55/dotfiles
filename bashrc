
set -o notify

# Bring in system bashrc
test -r /etc/bashrc &&
      . /etc/bashrc

# shell opts. see bash(1) for details
shopt -s cdspell >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1
shopt -s checkwinsize >/dev/null 2>&1
complete -cf sudo

# fuck "you have new mail" 
unset MAILCHECK

# disable core dumps
ulimit -S -c 0

# default umask
umask 0022

# bring in sbins and /usr/local/bin
PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"
# put ~/bin on PATH if you have it
test -d "$HOME/bin" &&
PATH="$HOME/bin:$PATH"
# ruby gems
PATH="$PATH:/var/lib/gems/1.8/bin"

# detect interactive shell
case "$-" in
    *i*) INTERACTIVE=yes ;;
    *)   unset INTERACTIVE ;;
esac

# detect login shell
case "$0" in
    -*) LOGIN=yes ;;
    *)  unset LOGIN ;;
esac

# enable en_US locale w/ utf-8 encodings if not already configured
: ${LANG:="en_US.UTF-8"}
: ${LANGUAGE:="en"}
: ${LC_CTYPE:="en_US.UTF-8"}
: ${LC_ALL:="en_US.UTF-8"}
export LANG LANGUAGE LC_CTYPE LC_ALL

# ignore python bytecode, vim swap files
FIGNORE=".pyc:.swp:.swa"

# bash history stuff
HISTCONTROL=ignoreboth
HISTFILESIZE=10000
HISTSIZE=10000

# set the EDITOR
test -n "$HAVE_VIM" &&
EDITOR=vim ||
EDITOR=vi
export EDITOR

# PAGER
if test -n "$(command -v less)" ; then
    PAGER="less -FirSwX"
    MANPAGER="less -FiRswX"
else
    PAGER=more
    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# Ack
ACK_PAGER="$PAGER"
ACK_PAGER_COLOR="$PAGER"

# See what we have to work with ...
HAVE_VIM=$(command -v vim)
HAVE_GVIM=$(command -v gvim)

RED="\[\033[0;31m\]"
BROWN="\[\033[0;33m\]"
GREY="\[\033[0;97m\]"
BLUE="\[\033[0;32m\]"
PS_CLEAR="\[\033[0m\]"
SCREEN_ESC="\[\033k\033\134\]"

COLOR1="${GREY}"
COLOR2="${GREY}"
P="\$"

prompt_simple() {
    unset PROMPT_COMMAND
    PS1="[\u@\h:\w]\$ "
    PS2="> "
}

prompt_compact() {
    unset PROMPT_COMMAND
    PS1="${COLOR1}${P}${PS_CLEAR} "
    PS2="> "
}

prompt_color() {
    PS1="${GREY}[${COLOR1}\u${GREY}${GREY}:${COLOR1}\W${GREY}]${COLOR2}$P${PS_CLEAR} "
    PS2="\[[33;1m\]continue \[[0m[1m\]> "
}

# override and disable tilde expansion
_expand() {
    return 0
}

# we always pass these to ls(1)
LS_COMMON="-hBG"

# if the dircolors utility is available, set that up to
dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    COLORS=/etc/DIR_COLORS
    test -e "/etc/DIR_COLORS.$TERM"   && COLORS="/etc/DIR_COLORS.$TERM"
    test -e "$HOME/.dircolors"        && COLORS="$HOME/.dircolors"
    test ! -e "$COLORS"               && COLORS=
    eval `$dircolors --sh $COLORS`
}
unset dircolors

# `ls` aliases
# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
alias ls="command ls $LS_COMMON"
# these use the ls aliases above
alias ll="ls -l"
alias l.="ls -d .*"

. ~/.bash_aliases

# git aliases
# put a little sugar in my bowl: http://defunkt.io/hub/
alias git=hub
alias ga="git add -p"
alias gc="git commit -m"
alias gs="git status"
alias gp="git pull --rebase"
alias gu="git push origin"
alias gb="git branch"

# apache aliases
alias a2r="apache2ctl restart"
alias a2cc="apache2ctl -t"
alias a2stp="apache2ctl stop"
alias a2str="apache2ctl start"

# random aliases
# disk usage with human sizes and minimal depth
alias du1='du -h --max-depth=1'
alias fn='find . -name'
alias hi='history | tail -20'
alias bitch,='sudo'
# Shows most used commands
alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

# Usage: pls [<var>]
# List path entries of PATH or environment variable <var>.
pls () { eval echo \$${1:-PATH} |tr : '\n'; }

# push SSH public key to another box
push_ssh_cert() {
    local _host
    test -f ~/.ssh/id_rsa.pub || ssh-keygen -t rsa
    for _host in "$@";
    do
        echo $_host
        ssh $_host 'cat >> ~/.ssh/authorized_keys' < ~/.ssh/id_rsa.pub
    done
}

# Usage: pshift [-n <num>] [<var>]
# Shift <num> entries off the front of PATH or environment var <var>.
# with the <var> option. Useful: pshift $(pwd)
pshift () {
    local n=1
    [ "$1" = "-n" ] && { n=$(( $2 + 1 )); shift 2; }
    eval "${1:-PATH}='$(pls |tail -n +$n |tr '\n' :)'"
}

# Usage: ppop [-n <num>] [<var>]
# Pop <num> entries off the end of PATH or environment variable <var>.
ppop () {
    local n=1 i=0
    [ "$1" = "-n" ] && { n=$2; shift 2; }
    while [ $i -lt $n ]
    do eval "${1:-PATH}='\${${1:-PATH}%:*}'"
       i=$(( i + 1 ))
    done
}

# Usage: prm <path> [<var>]
# Remove <path> from PATH or environment variable <var>.
prm () { eval "${2:-PATH}='$(pls $2 |grep -v "^$1\$" |tr '\n' :)'"; }

# Usage: punshift <path> [<var>]
# Shift <path> onto the beginning of PATH or environment variable <var>.
punshift () { eval "${2:-PATH}='$1:$(eval echo \$${2:-PATH})'"; }

# Usage: ppush <path> [<var>]
ppush () { eval "${2:-PATH}='$(eval echo \$${2:-PATH})':$1"; }

# Usage: puniq [<path>]
# Remove duplicate entries from a PATH style value while retaining
# the original order. Use PATH if no <path> is given.
#
# Example:
#   $ puniq /usr/bin:/usr/local/bin:/usr/bin
#   /usr/bin:/usr/local/bin
puniq () {
    echo "$1" |tr : '\n' |nl |sort -u -k 2,2 |sort -n |
    cut -f 2- |tr '\n' : |sed -e 's/:$//' -e 's/^://'
}

# Usage: chunnel <local-port> [<remote-port>]
function chunnel () {
    LOCAL=$1
    REMOTE=$2
    if [ -z $REMOTE ]; then
        REMOTE=$LOCAL
    fi
    echo "Broadcasting local port $LOCAL to http://chunnel.2tor.com:$REMOTE ..."
    ssh -nNT -R *:$REMOTE:0.0.0.0:$LOCAL chunnel
}

# iTerm Integration with growl.
# Get notifications when long running tasks finish
# Usage: some_long_running_task && growl
growl() { echo -e $'\e]9;'${@}'\007'; return; }

# condense PATH entries
PATH=$(puniq $PATH)
MANPATH=$(puniq $MANPATH)

# Use the color prompt by default when interactive
test -n "$PS1" &&
prompt_color

test -n "$INTERACTIVE" -a -n "$LOGIN" && {
    uname -npsr
    uptime
}

[[ -s "$HOME/.secrets" ]] && source "$HOME/.secrets"

# Reload keychain
if [ -x /usr/bin/keychain -a -f $HOME/.keychain/${HOSTNAME}-sh -a -n "$INTERACTIVE" -a -n "$LOGIN" ]; then
    /usr/bin/keychain `find $HOME/.ssh/ -name "*id_rsa*" -not \( -name "*.pub" \)`
    source $HOME/.keychain/${HOSTNAME}-sh
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# prompt
PS1="\[$BLDBLK\]\n\u:\w \[$TXTBLU\](\$(srb_git_prompt)\[$TXTBLU\])\[$TXTRST\] \n→ "
export PROMPT_COMMAND=’echo -ne “\033]0;${USER}@${HOSTNAME%%.*}\007″‘

# vim: ts=4 sts=4 shiftwidth=4 expandtab

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
