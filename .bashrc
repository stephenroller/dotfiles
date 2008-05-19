# Stephen Roller's .bashrc.

case `uname` in
	Darwin)
		export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
		export PATH=/usr/local/MzScheme/bin:$PATH
		export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
		export EDITOR="mate -w"
		export CLICOLOR=1
		export MANPATH=$MANPATH:/opt/local/share/man
		
		# extra commands.
		alias startmysql="sudo launchctl load -w \ 
		    /opt/local/etc/LaunchDaemons/org.macports.mysql4/org.macports.mysql4.plist"
		;;
	Linux)
		alias ls="ls --color"
		;;
esac

export PYTHONPATH=$PYTHONPATH:~/.hgext
export PYTHONPATH=$PYTHONPATH:~/.pylibs



export HISTCONTROL=ignoreboth

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

# Colored shell depending on host
case `hostname` in
	faith.local)
		color=31
		;;
	"neuace.tenniscores.com")
		color=32
		;;
	godfather)
		color=33
		;;
	alicia)
		color=34
		;;
	"mshawking.asmallorange.com")
		color=35
		;;
	*)
		color=30
		;;
esac
export PS1="\[\033[00;${color}m\]\u \[\033[00m\]\W \$ ";

# SSH servers
alias ssh.ncsu="ssh -C scroller@remote-linux.eos.ncsu.edu"
alias ssh.srdotcom="ssh -C stephenroller.com"
alias ssh.mattroot="ssh root@71.65.228.210"
alias ssh.courtside-ec2="ssh ec2-75-101-218-196.compute-1.amazonaws.com"
alias ssh.tenniscores="ssh tenniscores.com"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias screen="screen -q"
alias clisp="clisp -q"
alias delete_orig="find ./ -iname '*.orig' -exec rm {} ';'"

# FORTUNE
which fortune > /dev/null 2>&1
if [ "$?" == "0" ]
then
	echo
	fortune
	echo
fi

