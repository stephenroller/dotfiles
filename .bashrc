# Stephen Roller's .bashrc.

case `uname` in
	Darwin)
		export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
		export PATH=/usr/local/MzScheme/bin:$PATH
		export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
		export EDITOR="mate -w"
		export CLICOLOR=1
		export MANPATH=$MANPATH:/opt/local/share/man
		export PYTHONPATH=$PYTHONPATH:/opt/local/lib/python2.5/site-packages/
		
		# extra commands.
		alias startmysql="sudo launchctl load -w \ 
		    /opt/local/etc/LaunchDaemons/org.macports.mysql4/org.macports.mysql4.plist"
		;;
	Linux)
		eval `dircolors -b`
		alias ls="ls --color"
		;;
esac

export PYTHONPATH=$PYTHONPATH:~/.hgext
export PYTHONPATH=$PYTHONPATH:~/.pylibs
PATH=.:~/bin:$PATH

export HISTCONTROL=ignoreboth

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
		export PATH=~/.mz/bin:$PATH
		;;
	*)
		color=30
		;;
esac

# SSH servers
alias ssh.ncsu="ssh -C scroller@remote-linux.eos.ncsu.edu"
alias ssh.srdotcom="ssh -C stephenroller.com"
alias ssh.courtside-ec2="ssh ec2-75-101-218-196.compute-1.amazonaws.com"
alias ssh.tenniscores="ssh tenniscores.com"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias screen="screen -q"
alias clisp="clisp -q"
alias delete_orig="find ./ -iname '*.orig' -exec rm {} ';'"



# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

export PS1="\[\033[00;${color}m\]\u \[\033[00m\]\W \$ ";

# FORTUNE
which fortune > /dev/null 2>&1
if [ "$?" == "0" ]
then
	echo
	fortune
	echo
fi

