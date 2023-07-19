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

cwd=$(pwd)

# the name of the script
script=$(basename "$0")

# dotfiles directory
dot_dir=$cwd

approve_vim_update="${APPROVE_VIM_UPDATE:-default}"

##########

#Help function
function HELP {
    echo "Help documentation for ${script}"
    echo -n "Install the dotfiles of this Dotfiles repository. Run this script"
    echo " in this Dotfiles folder."
    echo ""
    echo "Basic usage: ./$script"
    echo "-h    Displays this help message. No further functions are performed."
    echo ""
    echo "Example for installation: $script -i install"
    echo "Example for update: $script -i update"
}


while getopts "h" opt; do
    case $opt in
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
    sudo apt-get update;

    echo "install build-essential"
    sudo apt-get install -y build-essential;

    echo "install Python 3 packages"
    sudo apt-get install -y python3-pip \
                            python3-dev \
                            python3-venv \
                            python-is-python3;

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

    echo "install dconf-cli"
    sudo apt-get install -y dconf-cli;

    echo "install parallel"
    sudo apt-get install -y parallel;

    echo "install silversearcher-ag"
    sudo apt-get install -y silversearcher-ag;

    echo "install zsh"
    sudo apt-get install -y zsh
}

install_nodejs() {
    echo "install Node.js..."
    curl -sL \
        https://raw.githubusercontent.com/nodesource/distributions/66d777ee3fb7748b1c4b7d1d52511e6194fcda06/deb/setup_18.x \
        -o /tmp/nodesource_setup.sh
    sudo bash /tmp/nodesource_setup.sh
    sudo apt-get install -y nodejs
    echo "DONE"
}

install_coc_dependencies() {
    echo "install CoC dependencies..."
    install_nodejs
    sudo npm install --global yarn
    echo "DONE"
}

install_powerline() {
    echo "install powerline-status"
    pip3 install powerline-status

    echo "update fonts cache"
    fc-cache -vf "$HOME"/fonts/
}

update_vim() {
    if [ "$approve_vim_update" = true ]; then
        echo "install/update vim add-ons"
        vim +PlugUpdate +qall

        echo "upgrade vim-plug"
        vim +PlugUpgrade +qall
    fi
}

install_solarized() {
    echo "install solarized..."
    cd "$dot_dir"/gnome-terminal-colors-solarized/
    ./install.sh --scheme dark --profile solarized --skip-dircolors || true
    cd "$cwd"
    echo "DONE"
}

doinstalls() {
    install_solarized
    install_coc_dependencies
    install_powerline
    update_vim
}

install() {
    install_dependencies
    doinstalls
}

install
