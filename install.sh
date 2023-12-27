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


set -euo pipefail

cwd=$(pwd)

# the name of the script
script=$(basename "$0")

# dotfiles directory
dot_dir=$cwd

approve_vim_update="${APPROVE_VIM_UPDATE:-default}"

##########

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


install_nodejs() {
    echo "install Node.js..."
    echo "  download setup script"
    curl --verbose -sL \
        https://raw.githubusercontent.com/nodesource/distributions/66d777ee3fb7748b1c4b7d1d52511e6194fcda06/deb/setup_18.x \
        -o /tmp/nodesource_setup.sh
    echo "  execute setup script"
    sudo bash /tmp/nodesource_setup.sh
    echo "  install nodejs"
    sudo apt-get install -y nodejs
    echo "DONE"
}


install_coc_dependencies() {
    echo "install CoC dependencies..."
    install_nodejs
    sudo npm install --global yarn
    echo "DONE"
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
    "$dot_dir"/gnome-terminal-colors-solarized/install.sh \
        --scheme dark --profile solarized --skip-dircolors \
        || echo "WARNING: Failed to install solarized terminal colors"
    echo "DONE"
}


install() {
    install_solarized
    install_coc_dependencies
    update_vim
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

install
