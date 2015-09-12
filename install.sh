#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

#automatic quit, if error
set -e

dir=~/Dotfiles                    			# dotfiles directory
olddir=~/Dotfiles_old             			# old dotfiles backup directory
files="bashrc vimrc gitconfig bash_aliases"		# list of files/folders to symlink in homedir

##########

create_olddir() {

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"
}


symlink_files() {

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, 
#then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
}

install_dependencies() {

    platform=$(uname);
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/debian_version ]]; then

		echo "check if pip is installed, if not install"
		if [ $(dpkg-query -l | grep pip | wc -l) == 0 ];
		then
		  sudo apt-get install pip;
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
        fi
    elif [[ $platform == 'Darwin' ]]; then
		echo "Please install missing dependencies, then re-run this script!"
		exit
	else 
		echo "Platform $platform not known!"
		echo "This script might be not suitable for your platform"
		exit
    fi
}

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $HOME/.oh-my-zsh/ ]]; then
	echo "go into home folder"
	cd
	echo "done"

	echo "clone oh-my-zsh"
        git clone http://github.com/robbyrussell/oh-my-zsh.git
	echo "done"
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        fi
        echo "Please re-run this script for complete installation!"
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}


install_vim() {

    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d ~/.vim/bundle/Vundle.vim ]]; then
	echo "Clone the Vundle repo"
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	echo "done"
    fi

	echo "install vim add ons"
	vim +PluginInstall +qall
	echo "done"

	echo "install YouCompleteMe if it is a addon"
	if [ -f ~/.vim/bundle/YouCompleteMe/install.py ]; then
		python ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
	else 
		echo "YouCompleteMe has not been found"
	fi
	echo "done"
}

#check if bash is used
if [[ 0 == 0 ]]; then

	echo "start installation"
else
	echo "You need to use bash to run this script!"
	echo "Run the command: bash install.sh"
	exit
fi
install_dependencies
install_zsh
create_olddir
symlink_files
install_vim
echo "Everythin was installed just fine. Dofiles are updated :)"
