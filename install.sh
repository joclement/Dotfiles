#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

#automatic quit, if error
set -e

script=`basename $0`
my_home=$HOME 						# alternative home folder for installation
dir=$my_home/Dotfiles                  			# dotfiles directory
olddir=$my_home/Dotfiles_old           			# old dotfiles backup directory
files="bashrc vimrc gitconfig shared_aliases zshrc"	# list of files/folders to symlink in homedir
system_wide=false 					# whether to install system wide or for user

##########

#Help function
function HELP {
echo -e \\n"Help documentation for ${script}"\\n
echo "Installs the dotfiles of this git Dotfiles repository. You may need to give your passport
to install needed sytem wide software packages, f.x. cmake"
echo -e "Basic usage: ./$script "\\n
echo -e "-d    option to give base directory to where to link files, make and look for files and folders. 
      Folder needs to exist. 
      Normally this folder is the home directory, f.x. .vimrc is normally stored in $HOME/.vimrc. 
      Default value is $my_home . 
      Folder must not have a ending /"\\n
echo -e "-s    Install some parts system wide. Default is $system_wide" \\n
echo -e "-h    Displays this help message. No further functions are performed."\\n
echo -e "Example: $script -s -d $my_home/example_folder "\\n
exit 1
}

#check if bash is used
if [[ 0 == 0 ]]; then

	echo "start installation"
else
	echo "You need to use bash to run this script!"
	exit 1
fi

while getopts ":d:s h" opt; do
	case $opt in
		d)
			if [ -d "$OPTARG" ]; then
				if [[ -L "$OPTARG" ]]; then
					echo "specified directory is a link. EXIT!"
					exit 1
				else
					my_home=$OPTARG
				fi
			else
				echo "specified directory does not exist. EXIT!"
				exit 1
			fi
			;;
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
	echo -n "Creating $olddir for backup of any existing dotfiles in $my_home ..."
	mkdir -p $olddir
	echo "done"
}


symlink_files() {

	# move any existing dotfiles in homedir to dotfiles_old directory, 
	#then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
	for file in $files; do
		echo "Moving any existing dotfiles from $my_home to $olddir"
		if [ -f "$my_home/.$file" ]; then
		mv $my_home/.$file $my_home/dotfiles_old/
		fi
		echo "done"
		echo "Creating symlink to $file in $my_home directory."
		ln -s $dir/$file $my_home/.$file
		echo "done"
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
		if [[ ! -d $my_home/.oh-my-zsh/ ]]; then
			echo "go into home folder"
			cd $my_home
			echo "done"

			echo "clone oh-my-zsh"
			git clone http://github.com/robbyrussell/oh-my-zsh.git $my_home/.oh-my-zsh/
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
	if [[ ! -d $my_home/.vim/bundle/Vundle.vim ]]; then
		echo "Clone the Vundle repo"
		git clone https://github.com/gmarik/Vundle.vim.git $my_home/.vim/bundle/Vundle.vim
		echo "done"
	fi

	echo "install vim add ons"
	vim +PluginInstall +qall
	echo "done"

	echo "install YouCompleteMe if it is a addon"
	if [ -f $my_home/.vim/bundle/YouCompleteMe/install.py ]; then
		python $my_home/.vim/bundle/YouCompleteMe/install.py --clang-completer
	else 
		echo "YouCompleteMe has not been found"
	fi
	echo "done"
}


install_dependencies
install_zsh
create_olddir
symlink_files
install_powerline
install_vim
echo "Everythin was installed just fine. Dofiles are updated :)"
