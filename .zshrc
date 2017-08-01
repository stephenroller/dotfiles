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
# if a command took more than 30s, show runtime statistics
export REPORTTIME=30

# not all machines have md5sum -_-
if (( $+commands[md5] )); then
    alias md5sum=md5
fi
HOSTHASH=`hostname -f | sed 's/^[^.]*\.//' | md5sum | sed "s/[^0-9]//g" | cut -c1-10`

(( HOSTHASH = ($HOSTHASH % 64) + 65 ))
HOSTCOLOR="`tput setaf $HOSTHASH`"

mkdir -p ~/.logs/zsh/

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
    PROMPT="%{${HOSTCOLOR}%}%m %F{reset%}%c %F{$promptcolor%}$promptchar %F{reset%}"

    echo "$(date "+%Y-%m-%d\t%H:%M:%S")\t${HOST}\t$(pwd)\t${last_return}\t$(fc -l -1 | sed 's#^[0-9][0-9]*  *##')" >> ~/.logs/zsh/history_$(date "+%Y%m").log
}

function preexec() {
    export _CMD_START_TIME=`date +%s`
}



