# Stephen Roller's .bashrc.

export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/local/MzScheme/bin:$PATH
export CLICOLOR=1
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
export EDITOR="mate -w"
export PYTHONPATH=$PTYHONPATH:~/.hgext
export HISTCONTROL=ignoreboth
export MANPATH=$MANPATH:/opt/local/share/man

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

export PS1="\[\033[00;31m\]\u \[\033[00m\]\W \$ "

# SSH servers
alias ssh.ncsu="ssh -C scroller@remote-linux.eos.ncsu.edu"
alias ssh.srdotcom="ssh -C stephenroller.com"
alias ssh.mattroot="ssh root@71.65.228.210"
alias ssh.courtside-ec2="ssh ec2-75-101-218-196.compute-1.amazonaws.com"
alias ssh.tenniscores="ssh tenniscores.com"

# extra commands.
alias startmysql="sudo launchctl load -w \ 
    /opt/local/etc/LaunchDaemons/org.macports.mysql4/org.macports.mysql4.plist"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias screen="screen -q"
alias clisp="clisp -q"
alias delete_orig="find ./ -iname '*.orig' -exec rm {} ';'"
alias m="mate -w"

# FORTUNE
echo
fortune
echo
