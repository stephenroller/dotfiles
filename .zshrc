#!/bin/zsh

# history stuff
HISTFILE=~/.zsh_history
SAVEHIST=50000
HISTSIZE=50000
setopt SHARE_HISTORY

# emacs keybindings for the shell (gimme that ctrl-a and ctrl-e)
bindkey -e
# make delete key work
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char
bindkey "[D" backward-word
bindkey "[C" forward-word

# enable support for using # to ignore the line, since I use that
# to compose commands a lot.
set -k

# i like autocomplete updating often
zstyle ":completion:*:commands" rehash 1

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

if [ -f $HOME/.zshrc_private ]; then
    source $HOME/.zshrc_private
fi

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $TERM == "dumb" || $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

source "$HOME/.profile.d/interactive"

# PROMPTS

# color support
autoload -U colors && colors

## Completions
autoload -U compinit
compinit -C

## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# prompts
if (( $+commands[md5] )); then
    alias md5sum=md5
fi
HOSTHASH=`hostname | md5sum | sed "s/[^0-9]//g" | cut -c1-10`
(( HOSTHASH = ($HOSTHASH % 128) + 1 ))
HOSTCOLOR="`tput setaf $HOSTHASH`"

function precmd() {
    last_return=$?
    if (( $last_return == 0 )); then
        promptcolor="green"
    else
        promptcolor="red"
    fi
    if [[ $USER == "root" ]]; then
        promptchar="#"
    else
        promptchar="»"
    fi
    if (( $_CMD_START_TIME )); then
        CUR_TIME=`date +%s`
        (( LAST_CMD_FULLTIME = ($CUR_TIME - $_CMD_START_TIME) ))
        if (( $LAST_CMD_FULLTIME > 3 )); then
            (( LAST_CMD_MIN = $LAST_CMD_FULLTIME / 60 ))
            (( LAST_CMD_SEC = $LAST_CMD_FULLTIME % 60 ))
            local LAST_CMD_TIME="${LAST_CMD_MIN}m${LAST_CMD_SEC}s "
        else
            local LAST_CMD_TIME=""
        fi
        export _CMD_START_TIME=""
    else
        local LAST_CMD_TIME=""
    fi
    if [[ $USER == "stephen" ]]; then
        local _DISP_USER="sr"
    else
        local _DISP_USER="$USER"
    fi
    NICEPATH="`pwd | sed -e \"s#$HOME#~#\" | perl -p -e 's/(\w\w)\w+\//\$1\//g'`"

    PROMPT="%{${HOSTCOLOR}%}${_DISP_USER} %F{reset%}${NICEPATH} %F{$promptcolor%}$promptchar %F{reset%}"
    if [[ "$LAST_CMD_TIME" != "" ]]; then
        FINISH_DATE="$( date )"
        PROMPT="%F{magenta%}$LAST_CMD_TIME%F{reset%} @ %F{yellow%}$FINISH_DATE%F{RESET%}
$PROMPT"
    fi
    #RPROMPT="$LAST_CMD_TIME"
    RPROMPT=""
}

function preexec() {
    export _CMD_START_TIME=`date +%s`
}



