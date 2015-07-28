#!/bin/bash

BASEDIR=~/Dotfiles

# bash
ln -s ${BASEDIR}/bash/.bashrc ~/.bashrc
ln -s ${BASEDIR}/bash/.bash_aliases ~/.bash_aliases

# git
ln -s ${BASEDIR}/git/.gitconfig ~/.gitconfig

# vim
ln -s ${BASEDIR}/vim/.vimrc ~/.vimrc
