# Stephen Roller's .bashrc.

export HISTCONTROL=ignoreboth
export PAGER="less"

case `uname` in
	Darwin)
		export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
		export PATH=/usr/local/MzScheme/bin:$PATH
		export GIT_PAGER="less"
		export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
		export EDITOR="mate_wait"
		export CLICOLOR=1
		export MANPATH=$MANPATH:/opt/local/share/man
		export PYTHONPATH=$PYTHONPATH:/opt/local/lib/python2.5/site-packages/
		
		function proxy ()
		{
			sudo networksetup -setsocksfirewallproxystate Ethernet $1 &&
			sudo networksetup -setsocksfirewallproxystate Airport $1
		}
		function proxyall ()
		{
			proxy on &&
			ssh tenniscores.com -D 9999 -L 2525:localhost:25;
			proxy off
		}
		
		function courtside ()
		{
			cd ~/Working/courtside
			export DJANGO_SETTINGS_MODULE=settings.development_stephen
			alias pmr="pm runserver"
			alias pms="pm shell"
			alias clear_cache="echo 'delete from cache;' | pm dbshell"
		}
		
		alias mzscheme="rlwrap mzscheme"
		alias dockflat="defaults write com.apple.dock no-glass -boolean YES; killall Dock"
		alias dock3d="defaults write com.apple.dock no-glass -boolean NO; killall Dock"
		alias flushdns="dscacheutil -flushcache"
		alias port="sudo port"
		alias startmysql="sudo launchctl load -w \
			/Library/LaunchDaemons/com.mysql.mysqld.plist"
		alias stopmysql="sudo launchctl unload -w \
			/Library/LaunchDaemons/com.mysql.mysqld.plist"


		if [ -f /opt/local/etc/bash_completion ]; then
		    . /opt/local/etc/bash_completion
		fi
		;;
	Linux)
		eval `dircolors -b`
		alias ls="ls --color"
		;;
esac

if [ `hostname` == 'cheddar' ]
then
	alias snapshottm="/System/Library/CoreServices/backupd.bundle/Contents/Resources/backupd-helper"
fi


export PYTHONSTARTUP="$HOME/.pythonrc.py"
export PYTHONPATH=$PYTHONPATH:~/.hgext
export PYTHONPATH=$PYTHONPATH:~/.pylibs
PATH=.:~/bin:$PATH

# Colored shell depending on host
# case `hostname` in
# 	"mshawking.asmallorange.com")
# 		export PATH=~/.mz/bin:$PATH
# 		;;
# esac

# SSH servers
alias ssh.ncsu="ssh -YC scroller@remote-linux.eos.ncsu.edu"
alias ssh.srdotcom="ssh -C stephenroller.com"
alias ssh.courtside-dev="ssh -i ~/.ssh/courtside.pem root@dev.getcourtside.com"
alias ssh.courtside-live="ssh -i ~/.ssh/courtside.pem root@www.getcourtside.com"
alias ssh.tenniscores="ssh tenniscores.com -L 2525:localhost:25"

alias irc="ssh -t franky TERM=screen screen -t IRC -x -R -S irc irssi"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias screen="screen -q"
alias clisp="clisp -q"
alias delete_orig="find ./ -name '*.orig' -exec rm {} ';'"
alias pm="python manage.py"
alias col1="awk '{print \$1}'"
alias beep="echo -ne '\a'"
alias beeploop="while [ 1 ]; do beep; sleep 2; done"


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

export PROMPT_COMMAND='PS1="`python ~/.shellprompt.py $? 2>/dev/null`"'

# FORTUNE
which fortune > /dev/null 2>&1
if [ "$?" == "0" ]
then
	echo
	fortune
	echo
fi
