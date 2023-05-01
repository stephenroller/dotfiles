#!/usr/bin/env bash

for dotfile in .bashrc .vimrc .gitconfig .nethackrc .tmux.conf .ipython .zshrc .profile.d
do
	ln -fs "`pwd`/$dotfile" ~/$dotfile
done

if [ ! -s ~/.vim ]; then
    ln -s "`pwd`/.vim" ~/.vim
fi
