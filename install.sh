#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

#automatic quit, if error
set -e

script=`basename $0`
dir=~/Dotfiles                    			# dotfiles directory
olddir=~/Dotfiles_old             			# old dotfiles backup directory
files="bashrc vimrc gitconfig bash_aliases"		# list of files/folders to symlink in homedir
system_wide=false 					# whether to install system wide or for user

##########

#Help function
function HELP {
echo -e \\n"Help documentation for ${script}"\\n
echo "Installs the dotfiles of this git Dotfiles repository. You may need to give your passport
to install needed sytem wide software packages, f.x. cmake"
echo -e "Basic usage: bash $script "\\n
echo "-s    Install some parts system wide. Default is $system_wide"
echo -e "-h    Displays this help message. No further functions are performed."\\n
echo -e "Example: $script -s "\\n
exit 1
}

while getopts ":s h" opt; do
	case $opt in
		s)
			system_wide=true
			;;
		h)
			HELP;
			;;
		\?)
			echo "Invalid option:
			-$OPTARG" >&2
			HELP;
			;;
	esac
done


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

install_powerline() {

	echo "check if powerline is installed, if not install"
	if [ $(pip list | grep powerline-status | wc -l) == 0 ];
	then
		if [ "$system_wide" = true ]; then
			echo "installing system wide"
			sudo pip install powerline-status;
		else
			echo "installing for user"
			pip install --user powerline-status;
		fi
	fi
	echo "done"

	echo "install powerline fonts"

	wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf;
	wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf;
	if [ "$system_wide" = true ]; then
		echo "installing system wide..."
		echo "move PowerlineSymbols to /usr/share/fonts/"
		sudo mv PowerlineSymbols.otf /usr/share/fonts/
		echo "update fonts cache"
		sudo fc-cache -vf
		echo "move fonts conf to /etc/fonts/conf.d/"
		sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
	else
		echo "installing for user..."
		echo "move PowerlineSymbols to ~/.fonts/, create folder if non-existing"
		mkdir -p ~/.fonts/
		mv PowerlineSymbols.otf ~/.fonts/
		echo "update fonts cache"
		fc-cache -vf ~/.fonts/
		echo "move fonts conf to ~/.config/fontconfig/conf.d/, create folder if non-existing"
		mkdir -p ~/.config/fontconfig/conf.d/
		mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/
	fi
	echo "done"
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
install_powerline
install_vim
echo "Everythin was installed just fine. Dofiles are updated :)"
