# Stephen Roller's .bashrc.

export HISTCONTROL=ignoreboth
export PAGER="less"
export HISTSIZE=5000
export EDITOR="vim -f"

case `uname` in
	Darwin)
		export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH
		export PATH=/usr/local/MzScheme/bin:$PATH
        export PATH=/Library/PostgreSQL/9.0/bin:$PATH
        export PATH=/usr/local/share/mongo:$PATH
		export GIT_PAGER="less"
		export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
		#export EDITOR="mate_wait"
		export CLICOLOR=1
		export MANPATH=$MANPATH:/opt/local/share/man
		export PYTHONPATH=$PYTHONPATH:/opt/local/lib/python2.5/site-packages/
        export FALLBACK_DYLD_LIBRARY_PATH=/opt/local/lib:/opt/local/lib/postgresql83
		
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
			/Library/LaunchDaemons/org.macports.mysql5.plist"
		alias stopmysql="sudo launchctl unload -w \
			/Library/LaunchDaemons/org.macports.mysql5.plist"

		alias backupsms="scp iphone:/var/mobile/Library/SMS/sms.db /Users/stephen/Documents/"

        alias screensaverbg="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background"
		
		# puts the mac to sleep
		alias zzz="osascript -e 'tell application \"System Events\" to sleep'"

		if [ -f /opt/local/etc/bash_completion ]; then
		    . /opt/local/etc/bash_completion
		fi

        if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
        fi

		;;
	Linux)
		eval `dircolors -b`
		alias ls="ls --color"
		;;
esac


if [ -f ~/.bashrc_private ]; then
    source ~/.bashrc_private
fi

if [ `hostname` == 'cheddar' ]
then
alias snapshottm="/System/Library/CoreServices/backupd.bundle/Contents/Resources/backupd-helper"
fi

export PYTHONSTARTUP="$HOME/.pythonrc.py"
export PYTHONPATH=$PYTHONPATH:~/.hgext
export PYTHONPATH=$PYTHONPATH:~/.pylibs
export PYTHONPATH=$PYTHONPATH:~/Working/transloc_modules
PATH=.:~/bin:$PATH

alias irc="ssh -t gumby TERM=screen screen -t IRC -x -R -S irc irssi"
alias rpg="ssh -t tennis TERM=screen screen -t RPG -x -R -S rpg /usr/games/bin/angband"

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
alias plsed="perl -i -p -e"

function prowl () {
    curl -f 'https://api.prowlapp.com/publicapi/add' -d "apikey=`cat ~/.prowlkey | head -c 40`" --data-urlencode "description=$1" -d "application=`hostname`" > /dev/null 2>&1
}

function trash () {
	mv $@ ~/.Trash/
}

function calc () {
	echo "$@" | bc -l -q -i
}

function tostorage () {
	scp -r "$1" stephenroller.com:~/www/stephenroller.com/storage/uploaded/
	echo "http://stephenroller.com/storage/uploaded/`basename $1`"
}

function tolj () {
	scp -r "$1" stephenroller.com:~/www/stephenroller.com/storage/lj/
	echo "http://stephenroller.com/storage/lj/$1"
}

function utsh () {
    ssh $1.cs.utexas.edu
}

function freq() {
    sort $* | uniq -c | sort -rn;
}


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $TERM == "dumb" || $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

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
	"cheddar" )
		COLOR="$LIGHT_MAGENTA";;
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

if [ -f /usr/bin/ec2metadata ]; then
    HASH=$[ `ec2metadata | grep instance-id | md5sum | sed 's/[^0-9]//g' | head -c 6` % 180 + 13 ]
    COLOR="`EXT_COLOR $HASH`"
    NICE_HOSTNAME="`ec2metadata | grep public-hostname | awk '{print $2}' | sed 's/\..*$//' | sed 's/-/./g' | sed 's/\./-/'`"
fi

if [ $USER == "stephen" ]; then
	nice_username="sr"
else
	nice_username="$USER"
fi

function prompt_command () {
	GOOD=$?
	
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


# FORTUNE
which fortune > /dev/null 2>&1
if [ "$?" == "0" ] && [ "$CONQUE" != "1" ]
then
	echo
	fortune
	echo
fi

