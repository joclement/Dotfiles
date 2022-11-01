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

# alternative home folder for installation
my_home=$HOME

# folder to install repos, which are not in the ubuntu packages
local_software=$my_home/local_software

# dotfiles directory
dot_dir=$cwd

# old dotfiles backup directory
olddir=$my_home/Dotfiles_old

# list of files/folders to symlink in homedir
files="env shared_shell shared_aliases
       profile
       bash_profile bashrc
       inputrc
       zshenv zprofile zshrc antigen dircolors-solarized
       autocompletion_zsh zsh-syntax-highlighting
       vimrc gvimrc vim/ftplugin/* vim/ftdetect/* vim/autoload/*
       ideavimrc
       config/zathura/zathurarc
       tmux.conf
       gitconfig gitignore"

dirs="vim/autoload vim/ftplugin vim/plugin vim/ftdetect
      config/zathura
      zfunc"

# whether to install system wide or for user
approve_solarized_install=true
approve_vim_update=true
system_wide=false
installoption=""
changedefzsh=true

##########

#Help function
function HELP {
    echo "Help documentation for ${script}"
    echo -n "Install the dotfiles of this Dotfiles repository. Run this script"
    echo " in this Dotfiles folder."
    echo ""
    echo "Basic usage: ./$script"
    echo "-i    gives an installoption, necessary option."
    echo "      Use either \"update\" or \"install\" as an argument."
    echo "-s    Install some parts system wide. Default is $system_wide"
    echo "-n    Do not set zsh as default shell"
    echo "-o    Do not install solarized for gnome-terminal"
    echo "-v    Do not install/update vim addons"
    echo "-h    Displays this help message. No further functions are performed."
    echo ""
    echo "Example for installation: $script -i install"
    echo "Example for update: $script -i update"
}

#check if bash is used
if [[ 0 == 0 ]];
then
    echo ""
else
    echo "You need to use bash to run this script!"
    exit 1
fi

while getopts ":i:s n h o v" opt; do
    case $opt in
        i)
            if [ "$OPTARG" == "update" -o "$OPTARG" == "install" ];
            then
                installoption="$OPTARG"
            else
                echo "$OPTARG is not a valid argument. EXIT!"
                HELP;
                exit 1
            fi
            ;;
        s)
            system_wide=true
            ;;
        n)
            changedefzsh=false
            ;;
        o)
            approve_solarized_install=false
            ;;
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


create_olddir() {
    echo -n "Creating $olddir for backup of any existing dotfiles"
    if [ ! -f "$olddir" ];
    then
        mkdir -p $olddir
    else
        echo "There is a file named $olddir, which should be the backup dir"
        exit 1
    fi
    echo "done"
}


symlink_files() {
    for dir in $dirs; do
        echo "Create dotfile dir: $dir"
        if [ ! -f "$my_home/.$dir" ];
        then
            mkdir -p $my_home/.$dir
        else
            echo "There is a file named $dir, which is supposed to be
            a directory"
            exit 1
        fi
    done
    for file in $files; do
        echo "Moving any existing dotfiles from $my_home to $olddir"
        if [ -f "$my_home/.$file" ];
        then
            echo "Move $file into $olddir"
            mv $my_home/.$file $olddir
        elif [ -d "$my_home/.$file" ];
        then
            if [ -L "$my_home/.$file" ]
            then
                rm $my_home/.$file
            else
                echo "This dir $file should be a file. EXIT!"
                exit 1
            fi
        else
            echo "This link $file does not exist yet in the $my_home dir."
        fi
        echo "done"
        echo "Creating symlink to $file in $my_home directory."
        ln -s $dot_dir/$file $my_home/.$file
        echo "done"
    done
}

install_dependencies() {
    platform=$(uname);
    if [[ $platform == 'Linux' ]];
    then
        if [[ -f /etc/debian_version ]];
        then
            echo "install build-essential"
            sudo apt-get install -y build-essential;
            echo "done"

            echo "install cmake"
            sudo apt-get install -y cmake;
            echo "done"

            echo "install pip3"
            sudo apt-get install -y python3-pip;
            echo "done"

            echo "install python3-dev"
            sudo apt-get install -y python3-dev;
            echo "done"

            echo "install python3-venv"
            sudo apt-get install -y python3-venv;
            echo "done"

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
            echo "done"

            echo "install vim"
            sudo apt-get install -y vim-gtk;
            echo "done"

            echo "install git"
            sudo apt-get install -y git;
            echo "done"

            echo "install fontconfig for fc-cache"
            sudo apt-get install -y fontconfig;
            echo "done"

            echo "install curl"
            sudo apt-get install -y curl;
            echo "done"

            echo "install dh-autoreconf for ctags"
            sudo apt-get install -y dh-autoreconf;
            echo "done"

            echo "install pkg-config for ctags"
            sudo apt-get install -y pkg-config;
            echo "done"

            echo "install dconf-cli"
            sudo apt-get install -y dconf-cli;

            echo "install global(gtags)"
            sudo apt-get install -y global;

            echo "install parallel"
            sudo apt-get install -y parallel;

            echo "install silversearcher-ag"
            sudo apt-get install -y silversearcher-ag;
        fi
    else
        echo "This script is not suitable in this form for your platform"
        echo "If your are sure to use it, edit this script."
        exit 1
    fi
}

default_zsh() {
    if [ "$changedefzsh" == "true" ];
    then
        # Set the default shell to zsh if it isn't currently set to zsh
        if [[ ! $(echo $SHELL) == $(which zsh) ]];
        then
            echo "change default shell to zsh..."
            chsh -s $(which zsh)
            echo "done"
        fi
    fi
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

install_zsh() {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh -o -f /usr/bin/zsh ];
    then
        default_zsh
    else
        # If zsh isn't installed, get the platform of the current machine
        platform=$(uname);
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        if [ $platform == 'Linux' ] && [ -f /etc/debian_version ];
        then
            sudo apt-get install -y zsh
            install_zsh
        else
            echo "This script is not suitable in this form for your platform."
            echo "If your are sure to use it, edit this script."
            exit 1
        fi
    fi
}

install_powerline() {
    echo "check if powerline is installed, if not install"
    if [ $(pip3 list | grep powerline-status | wc -l) == 0 ];
    then
        if [ "$system_wide" == true ];
        then
            echo "installing system wide"
            sudo pip3 install powerline-status;
        else
            echo "installing for user"
            pip3 install --user powerline-status;
        fi
    fi
    echo "done"

    echo "install powerline fonts"

    if [ "$system_wide" == true ];
    then
        echo "installing system wide..."
        echo "move PowerlineSymbols to /usr/share/fonts/"
        sudo cp $dot_dir/fonts/PowerlineSymbols.otf /usr/share/fonts/
        echo "update fonts cache"
        sudo fc-cache -vf
        echo "move fonts conf to /etc/fonts/conf.d/"
        sudo cp $dot_dir/fonts/10-powerline-symbols.conf /etc/fonts/conf.d/
    else
        echo "installing for user..."
        echo "move PowerlineSymbols to $my_home/fonts/, \
            create folder if non-existing"
        mkdir -p $my_home/fonts/
        cp $dot_dir/fonts/PowerlineSymbols.otf $my_home/fonts/
        echo "update fonts cache"
        fc-cache -vf $my_home/fonts/
        echo "move fonts conf to $my_home/config/fontconfig/conf.d/, \
            create folder if non-existing"
        mkdir -p $my_home/config/fontconfig/conf.d/
        cp $dot_dir/fonts/10-powerline-symbols.conf \
            $my_home/config/fontconfig/conf.d/
    fi
    echo "done"
}

update_vim() {
    if [ "$approve_vim_update" == true ]; then
        echo "install vim add-ons"
        vim +PlugUpdate +qall
        echo "done"
    fi
}

install_solarized() {
    echo "install solarized..."
    cd $dot_dir/gnome-terminal-colors-solarized/
    ./install.sh --scheme dark --profile solarized --skip-dircolors
    cd $cwd
    echo "DONE"
}

checked_install_solarized() {
    if [ "$approve_solarized_install" == true ]; then
        install_solarized
    fi
}

dorequirements() {
    install_dependencies
    install_nodejs
    install_github_cli
    git submodule update --recursive --init
    install_zsh
}

backup_link() {
    create_olddir
    symlink_files
}

install_vimplug() {
    echo "install vimplug..."
    curl -fL -o $my_home/.vim/autoload/plug.vim \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "DONE"
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
        ln -s $local_software/${version}/gtags.vim $my_home/.vim/plugin/.
        echo "DONE"
    elif [ $(dpkg-query -l | grep global | wc -l) == 0 ];
    then
        if [ -f "/usr/local/share/gtags/gtags.vim" ]; then
            ln -s /usr/local/share/gtags/gtags.vim $my_home/.vim/plugin/.
        elif [ -f "/usr/share/vim/addons/gtags.vim" ]; then
            ln -s /usr/share/vim/addons/gtags.vim $my_home/.vim/plugin/.
        else
            echo "Couldn't find gtags vim plugin."
            exit 1
        fi
    fi
}

install_pyenv() {
    curl -L \
        https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer \
        | bash
}

doinstalls() {
    checked_install_solarized
    install_powerline
    install_vimplug
    mkdir -p $local_software
    install_ctags
    install_global
    install_pyenv
    update_vim
}

completeinstallation() {
    dorequirements
    backup_link
    doinstalls
}

update() {
    git submodule update --recursive --init
    backup_link
    update_vim
}

install() {
    if [ "$installoption" == "update" ];
    then
        update
    elif [ "$installoption" == "install" ];
    then
        completeinstallation
    fi
}
install
