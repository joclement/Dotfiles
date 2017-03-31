# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

#shows dots if waiting for autocompletion, ...
COMPLETION_WAITING_DOTS="true"

# DISABLE AUTOCORRECTION
DISABLE_CORRECTION="true"

export TERM="xterm-256color"

if [ -f $HOME/.private_zshrc ]; then
	source $HOME/.private_zshrc
fi

#########################################antigen stuff####################################

source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

#specify bundles
antigen bundles <<EOBUNDLES

# Guess what to install when running an unknown command
command-not-found

# Helper for extracting different types of archives
extract

#for working with git
git
git-extras
voronkovich/gitignore.plugin.zsh
github

# to go to parent dirs quickly
Tarrasch/zsh-bd

#for searching through history
history

# autcompletion for pip
pip

#more autocompletion
zsh-users/zsh-completions src

# mercurial auto completion and shortcuts
mercurial

EOBUNDLES
# TODO find way to add plugin based on version

# Load the theme.
antigen theme bhilburn/powerlevel9k powerlevel9k
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
if [ -n "$SSH_CLIENT" ]; then
    POWERLEVEL9K_CONTEXT_TEMPLATE="@%m"
fi
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# Tell antigen that you're done.
antigen apply

# User configuration

#export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"


# export MANPATH="/usr/local/man:$MANPATH"

#change SHELL variable to zsh, if using zsh
export SHELL=$(which zsh)

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#to include the shared shell settings, if they exist
if [ -f $HOME/.shared_shell ]; then
	source $HOME/.shared_shell
fi

#to include restricted autcompletion for zshrc
if [ -f $HOME/.autocompletion_zsh ]; then
	source $HOME/.autocompletion_zsh
fi

#use vim mode for zsh
bindkey -v
# to do backslash vim-like search faster
vi-search-fix() {
zle vi-cmd-mode
zle .vi-history-search-backward
}
autoload vi-search-fix
zle -N vi-search-fix
bindkey -M viins '\e/' vi-search-fix

#use history per tab and just merge after exit that shell
setopt APPEND_HISTORY
