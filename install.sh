#!/bin/bash
############################
# .make.sh
#
### Tested with Ubuntu! So not recommended for other operating systems without prior check
### and change!
#
### Prior to running the first time I would recommend to save the Dotfiles before,
### just in they get lost!
#
# This script sets up the Dotfiles environment from github.com/flyingdutchman23/Dotfiles.
# For that it checks whether the necessary software is available and installs it if
# needed.
# Then it installs the z shell and sets it as the default shell.
# After that it also saves the already existing Dotfiles in a directory specified by the variable
# olddir.
# Then this script creates symlinks from the home directory to any desired Dotfiles in the
# desired directory specified with the variable dir.
# Then it installs solarized. Information about that is available here:
# http://ethanschoonover.com/solarized/vim-colors-solarized
# It installs the powerline plug-in for vim and the z shell as well.
# At last it installs and updates all the vim plug-ins and recompiles YouCompleteMe if
# wanted.
#
# For the installation process the user can choose whether he wants to install certain
# parts system_wide or in the home folder.
# Currently the option is available for the powerline plug-in.
############################

########## Variables

#automatic quit, if error
set -e

cwd=`pwd`

# the name of the script
script=`basename $0`

# alternative home folder for installation
my_home=$HOME

# folder to install repos, which are not in the ubuntu packages
local_software=$my_home/local_software

# alternative home folder for installation
to_dots=$my_home

# dotfiles directory
dot_dir=$to_dots/Dotfiles

# old dotfiles backup directory
olddir=$to_dots/Dotfiles_old

# list of files/folders to symlink in homedir
files="bashrc vimrc gitconfig shared_aliases zshrc inputrc shared_shell\
	dircolors-solarized antigen vim/ftplugin/* env\
	autocompletion_zsh config/zathura/zathurarc tmux.conf hgrc"

dirs="vim/autoload vim/ftplugin config/zathura"

# whether to install system wide or for user
system_wide=false
installoption=""
recompileyoucompleteme=false
changedefzsh=true

##########

#Help function
function HELP {
    echo -e \\n"Help documentation for ${script}"\\n
    echo "Installs the dotfiles of this git Dotfiles repository. You may need to
    give your passport to install needed sytem wide software packages, f.x. cmake"
    echo -e "Basic usage: ./$script "\\n
    echo -e "-d    specify parent dir of Dotfiles git repo. Dotfiles has to be
    in that dir.
    Folder needs to exist.
    Normally this folder is the home directory, f.x. .vimrc is normally stored
    in $my_home/.vimrc.
    Default value is $to_dots .
    Folder must not have a ending /"\\n
    echo -e "-i    gives an installoption, necessary option.
    Use either \"update\" or \"install\" as an argument." \\n
    echo -e "-s    Install some parts system wide. Default is $system_wide" \\n
    echo -e "-n    Do not set zsh as default shell" \\n
    echo -e "-h    Displays this help message. No further functions are performed."\\n
    echo -e "Example for installation: $script -i install"\\n
    echo -e "Example for update: $script -i update"\\n
}

#check if bash is used
if [[ 0 == 0 ]];
then
    echo ""
else
    echo "You need to use bash to run this script!"
    exit 1
fi

while getopts ":d:i:s n h" opt; do
    case $opt in
        d)
            if [ -d "$OPTARG" ];
            then
                if [[ -L "$OPTARG" ]];
                then
                    echo "specified directory is a link. EXIT!"
                    exit 1
                else
                    to_dots=$OPTARG
                fi
            else
                echo "specified directory does not exist. EXIT!"
                HELP;
                exit 1
            fi
            ;;
        i)
            if [ "$OPTARG" = "update" -o "$OPTARG" = "install" ];
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
        h)
            HELP;
            exit 0
            ;;
        \?)
            echo "Invalid option:
            -$OPTARG" >&2
            HELP;
            exit 0
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
            echo "check if pip3 is installed, if not install"
            if [ $(dpkg-query -l | grep pip3 | wc -l) == 0 ];
            then
                sudo apt-get install python3-pip;
            fi
            echo "done"

            echo "check if build-essential is installed, if not install"
            if [ $(dpkg-query -l | grep build-essential | wc -l) == 0 ];
            then
                sudo apt-get install build-essential;
            fi
            echo "done"

            echo "check if cmake is installed, if not install"
            if [ $(dpkg-query -l | grep cmake | wc -l) == 0 ];
            then
                sudo apt-get install cmake;
            fi
            echo "done"

            echo "check if python-dev is installed, if not install"
            if [ $(dpkg-query -l | grep python-dev | wc -l) == 0 ];
            then
                sudo apt-get install python-dev;
            fi
            echo "done"

            echo "check if vim is installed, if not install"
            if [ $(dpkg-query -l | grep vim | wc -l) == 0 ];
            then
                sudo apt-get install vim;
            fi
            echo "done"

            echo "check if git is installed, if not install"
            if [ $(dpkg-query -l | grep git | wc -l) == 0 ];
            then
                sudo apt-get install git;
            fi
            echo "done"

            echo "check if dconf-cli is installed, if not install"
            if [ $(dpkg-query -l | grep dconf-cli | wc -l) == 0 ];
            then
                sudo apt-get install dconf-cli;
            fi
            echo "done"
        fi
    elif [[ $platform == 'Darwin' ]];
    then
        echo "This script might not be suitable for MAC OS, but you can
        try!"
        exit 1
    else
        echo "Platform $platform not known!"
        echo "This script might be not suitable for your platform"
        exit 1
    fi
}

default_zsh() {
    if [ "$changedefzsh" = "true" ];
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

install_zsh () {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh -o -f /usr/bin/zsh ];
    then
        default_zsh
    else
        # If zsh isn't installed, get the platform of the current machine
        platform=$(uname);
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        if [[ $platform == 'Linux' ]];
        then
            if [[ -f /etc/redhat-release ]];
            then
                sudo yum install zsh
                install_zsh
            fi
            if [[ -f /etc/debian_version ]];
            then
                sudo apt-get install zsh
                install_zsh
            fi

            # If the platform is OS X, tell the user to install zsh :)
        elif [[ $platform == 'Darwin' ]];
        then
            echo "Please install zsh, then re-run this script!"
            exit 1
        fi
    fi
}

install_powerline() {
    echo "check if powerline is installed, if not install"
    if [ $(pip3 list | grep powerline-status | wc -l) == 0 ];
    then
        if [ "$system_wide" = true ];
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

    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf;
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf;
    if [ "$system_wide" = true ];
    then
        echo "installing system wide..."
        echo "move PowerlineSymbols to /usr/share/fonts/"
        sudo mv PowerlineSymbols.otf /usr/share/fonts/
        echo "update fonts cache"
        sudo fc-cache -vf
        echo "move fonts conf to /etc/fonts/conf.d/"
        sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
    else
        echo "installing for user..."
        echo "move PowerlineSymbols to $my_home/fonts/, create folder if non-existing"
        mkdir -p $my_home/fonts/
        mv PowerlineSymbols.otf $my_home/fonts/
        echo "update fonts cache"
        fc-cache -vf $my_home/fonts/
        echo "move fonts conf to $my_home/config/fontconfig/conf.d/, create folder if non-existing"
        mkdir -p $my_home/config/fontconfig/conf.d/
        mv 10-powerline-symbols.conf $my_home/config/fontconfig/conf.d/
    fi
    echo "done"
}

update_vim() {
    echo "install vim add ons"
    vim +PlugUpdate +qall
    echo "done"
}

install_solarized() {
    cd $dot_dir/gnome-terminal-colors-solarized/
    . install.sh
    cd $cwd
}

dorequirements() {
    install_dependencies
    git submodule update --recursive --init
    install_zsh
}

backup_link() {
    create_olddir
    symlink_files
}

install_vimplug() {
    curl -fL -o $my_home/.vim/autoload/plug.vim \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_ctags() {
    cd $local_software
    git clone https://github.com/universal-ctags/ctags
    cd $local_software/ctags
    ./autogen.sh
    cd $local_software/ctags
    ./configure
    cd $local_software/ctags
    make
    cd $local_software/ctags
    sudo make install
    cd $cwd
}

install_global() {
    version='global-6.5.6'
    curl -fL -o $local_software/${version}.tar.gz http://tamacom.com/global/${version}.tar.gz
    cd $local_software
    tar -zxf ${version}.tar.gz
    cd $local_software/${version}
    ./configure
    cd $local_software/${version}
    make
    cd $local_software/${version}
    sudo make install
    cd $cwd
}

doinstalls() {
    echo "install solarized..."
    install_solarized
    echo "finish installtion solarized"
    install_powerline
    install_vimplug
    mkdir -p $local_software
    install_ctags
    install_global
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
    if [ "$installoption" = "update" ];
    then
        update
    elif [ "$installoption" = "install" ];
    then
        completeinstallation
    fi
}
install
