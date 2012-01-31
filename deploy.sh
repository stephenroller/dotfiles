#!/usr/bin/env bash

for dotfile in .bashrc .hgrc .screenrc .vimrc .inputrc .pythonrc.py .gitconfig .nethackrc .tmux.conf
do
	ln -fs "`pwd`/$dotfile" ~/$dotfile
done

if [ ! -s ~/.vim ]; then
    ln -s "`pwd`/.vim" ~/.vim
fi

# handle ssh config
if [ ! -d ~/.ssh ]; then

	mkdir -p ~/.ssh
	chmod 0700 ~/.ssh
fi
ln -fs "`pwd`/.sshconfig" ~/.ssh/config

