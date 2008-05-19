#!/usr/bin/env

for dotfile in .bashrc .hgrc .screenrc .vimrc .hgext
do
	ln -fs "`pwd`/$dotfile" ~/$dotfile
done

