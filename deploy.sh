#!/usr/bin/env bash

for dotfile in .bashrc .hgrc .screenrc .vimrc .inputrc .shellprompt.py .pythonrc.py .gitconfig
do
	ln -fs "`pwd`/$dotfile" ~/$dotfile
done

rmdir ~/.hgext 2>/dev/null
rm ~/.hgext 2>/dev/null
ln -s `pwd`/.hgext ~/

