# Stephen Roller's .bashrc.

# ignore duplicate history items
export HISTCONTROL=ignoreboth
# big ass history
export HISTSIZE=20000
# and constantly edit the history file
shopt -s histappend

# load everything else
source "$HOME/.profile.d/aliases"
source "$HOME/.profile.d/functions"
source "$HOME/.profile.d/vars"

if [ -f "$HOME/.profile.d/uname/`uname`" ]; then
    source "$HOME/.profile.d/uname/`uname`"
fi

if [ -f $HOME/.profile.private ]; then
    source $HOME/.profile.private
fi

if [ -f $HOME/.bashrc_private ]; then
    source $HOME/.bashrc_private
fi


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $TERM == "dumb" || $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

source "$HOME/.profile.d/interactive"


# colors stolen from http://www.logilab.org/blogentry/20255
NO_COLOR="\[\033[0m\]"
LIGHT_WHITE="\[\033[1;37m\]"
WHITE="\[\033[0;37m\]"
GRAY="\[\033[1;30m\]"
BLACK="\[\033[0;30m\]"
RED="\[\033[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
YELLOW="\[\033[0;33m\]"
LIGHT_YELLOW="\[\033[1;33m\]"
BLUE="\[\033[0;34m\]"
LIGHT_BLUE="\[\033[1;34m\]"
MAGENTA="\[\033[0;35m\]"
LIGHT_MAGENTA="\[\033[1;35m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
#function EXT_COLOR () { echo -ne "\[\033[38;5;$1m\]"; }
function EXT_COLOR () { echo -ne "\033[38;5;$1m"; }

NICE_HOSTNAME=""
case `hostname` in
    "neuace.tenniscores.com" )
        COLOR="$GREEN";;
    "trauerseeschwalbe.ims.uni-stuttgart.de" )
        COLOR="$MAGENTA";;
    "sven.sf.io" )
        COLOR="$LIGHT_BLUE";;
    "makurokurosuke")
        COLOR="$GRAY";;
    "provolone")
        COLOR="$LIGHT_YELLOW";;
    *)
        NICE_HOSTNAME="`hostname`"
        COLOR="";;
esac

function prompt_command () {
    GOOD=$?

    if [ $USER == "stephen" ]; then
        nice_username="sr"
    else
        nice_username="$USER"
    fi

    export PS1="${COLOR}${nice_username}"
    if [ "$NICE_HOSTNAME" != "" ]; then
        export PS1="${PS1}@$NICE_HOSTNAME"
    fi

    WPATH=`echo $PWD | sed "s#$HOME#~#"`
    WPATH2=""
    while [ "$WPATH" != "$WPATH2" ]; do
        WPATH2="$WPATH"
        WPATH=`echo $WPATH | sed "s#/\(..\)[^/][^/]*/#/\\1/#"`
    done
    if [ `echo $WPATH | wc -c` -gt 20 ]; then
        WPATH="\\W"
    fi

    export PS1="${PS1} ${NO_COLOR}${WPATH} "

    if [ $GOOD -eq 0 ]; then
        export PS1="${PS1}${LIGHT_GREEN}"
    else
        export PS1="${PS1}${LIGHT_RED}"
    fi
    export PS1="${PS1}\$${NO_COLOR} "
}

export PROMPT_COMMAND=prompt_command


