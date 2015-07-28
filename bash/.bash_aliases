#my bash aliases
alias ll='ls -l'
alias la='ls -al'
alias ..='cd ..'
alias l='ls -F1'
alias cl='reset'
alias kfi='pkill -f /usr/lib/firefox/firefox && (firefox &> /dev/null &)'
alias py='python'
alias pingTest='ping 8.8.8.8'
alias upd='sudo apt-get update'
alias upg='sudo apt-get upgrade'

#my alias functions

#opens a file the standard way and leads the output to null
function op {
	xdg-open $1 > /dev/null
	sleep 0.35
	:
}

function up () {
	sudo apt-get update;
	echo "Do you wish to upgrade?";
	varConfirmLoop=$(confirmLoop)
		if (( varConfirmLoop == 0 ));
	then
		sudo apt-get upgrade;
	fi;
}

function confirmLoop () {
	varConfirm=$(confirm);
	compare=2;
	while true;
	do
		if ((varConfirm == compare));
		then
			
			varConfirm=$(confirm);
		else
			break;
		fi;
	done;
	echo $varConfirm;
}

function confirm () {

	read -p "" choice;
	if [ "$choice" == "Y" ];
	then
		echo 0;
	elif [ "$choice" == "n" ];
	then
		echo 1;
	else 
		echo 2;
	fi;

}

#a function to create a directory and directly move into it
function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}
