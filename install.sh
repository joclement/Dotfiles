#!/bin/bash

# The license of this file is different than the others because it is based on
# content from the following repository:
# https://github.com/michaeljsmalley/dotfiles
#
############################
# Copyright (C) 2013  Michael J. Smalley

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
############################

############################
# Tested with Ubuntu! So not recommended for other operating systems without
# prior check and change!
#
# Prior to running this script I recommend to save the Dotfiles, just in case
# they get lost!
############################


set -e

cwd=`pwd`

# the name of the script
script=`basename $0`

# folder to install repos, which are not in the ubuntu packages
local_software=$HOME/local_software

# dotfiles directory
dot_dir=$cwd

# old dotfiles backup directory
olddir=$HOME/Dotfiles_old

approve_vim_update=true

##########

#Help function
function HELP {
    echo "Help documentation for ${script}"
    echo -n "Install the dotfiles of this Dotfiles repository. Run this script"
    echo " in this Dotfiles folder."
    echo ""
    echo "Basic usage: ./$script"
    echo "-v    Do not install/update vim addons"
    echo "-h    Displays this help message. No further functions are performed."
    echo ""
    echo "Example for installation: $script -i install"
    echo "Example for update: $script -i update"
}


while getopts ":i:s n h o v" opt; do
    case $opt in
        v)
            approve_vim_update=false
            ;;
        h)
            HELP;
            exit 0
            ;;
        \?)
            echo "Invalid option:
            -$OPTARG" >&2
            HELP;
            exit 1
            ;;
    esac
done


install_dependencies() {
    echo "install build-essential"
    sudo apt-get install -y build-essential;

    echo "install cmake"
    sudo apt-get install -y cmake;

    echo "install Python 3 packages"
    sudo apt-get install -y python3-pip python3-dev python3-venv;

    echo "install for pyenv"
    sudo apt-get install -y libedit-dev \
                            libssl-dev \
                            zlib1g-dev \
                            libbz2-dev \
                            libreadline-dev \
                            libsqlite3-dev \
                            llvm \
                            libncursesw5-dev \
                            xz-utils \
                            tk-dev \
                            libxml2-dev \
                            libxmlsec1-dev \
                            libffi-dev \
                            liblzma-dev;

    echo "install vim"
    sudo apt-get install -y vim-gtk;

    echo "install fontconfig for fc-cache"
    sudo apt-get install -y fontconfig;

    echo "install curl"
    sudo apt-get install -y curl;

    echo "install dh-autoreconf for ctags"
    sudo apt-get install -y dh-autoreconf;

    echo "install pkg-config for ctags"
    sudo apt-get install -y pkg-config;

    echo "install dconf-cli"
    sudo apt-get install -y dconf-cli;

    echo "install global(gtags)"
    sudo apt-get install -y global;

    echo "install parallel"
    sudo apt-get install -y parallel;

    echo "install silversearcher-ag"
    sudo apt-get install -y silversearcher-ag;

    echo "install zsh"
    sudo apt-get install -y zsh
}

install_nodejs() {
    curl -sL \
        https://raw.githubusercontent.com/nodesource/distributions/66d777ee3fb7748b1c4b7d1d52511e6194fcda06/deb/setup_18.x \
        -o nodesource_setup.sh
    sudo bash nodesource_setup.sh
    sudo apt-get install -y nodejs
}

install_github_cli() {
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
}

install_powerline() {
    echo "install powerline-status"
    pip3 install powerline-status

    echo "update fonts cache"
    fc-cache -vf $HOME/fonts/
}

update_vim() {
    if [ "$approve_vim_update" == true ]; then
        echo "install/update vim add-ons"
        vim +PlugUpdate +qall

        echo "upgrade vim-plug"
        vim +PlugUpgrade +qall
    fi
}

install_solarized() {
    echo "install solarized..."
    cd $dot_dir/gnome-terminal-colors-solarized/
    ./install.sh --scheme dark --profile solarized --skip-dircolors || true
    cd $cwd
    echo "DONE"
}

dorequirements() {
    install_dependencies
}

install_ctags() {
    echo "install ctags..."
    cd $local_software
    rm -rf ctags
    git clone https://github.com/universal-ctags/ctags
    cd $local_software/ctags
    git checkout d8f5c062ea6ff484f4f1f5095a7d3c364f3019ea
    ./autogen.sh
    ./configure
    make
    sudo make install
    cd $cwd
    echo "DONE"
}

install_global() {
    if [ ! command -v foo >/dev/null 2>&1 ]; then
        echo "install global..."
        version='global-6.5.6'
        curl -fL -o $local_software/${version}.tar.gz \
            http://tamacom.com/global/${version}.tar.gz
        cd $local_software
        rm -rf ${version}
        tar -zxf ${version}.tar.gz
        cd $local_software/${version}
        ./configure
        cd $local_software/${version}
        make
        cd $local_software/${version}
        sudo make install
        cd $cwd
        ln -s $local_software/${version}/gtags.vim $HOME/.vim/plugin/.
        echo "DONE"
    elif [ $(dpkg-query -l | grep global | wc -l) == 0 ];
    then
        if [ -f "/usr/local/share/gtags/gtags.vim" ]; then
            ln -s /usr/local/share/gtags/gtags.vim $HOME/.vim/plugin/.
        elif [ -f "/usr/share/vim/addons/gtags.vim" ]; then
            ln -s /usr/share/vim/addons/gtags.vim $HOME/.vim/plugin/.
        else
            echo "Couldn't find gtags vim plugin."
            exit 1
        fi
    fi
}

doinstalls() {
    install_solarized
    install_github_cli
    install_nodejs
    install_powerline
    install_ctags
    install_global
    update_vim
}

install() {
    dorequirements
    doinstalls
}

install
