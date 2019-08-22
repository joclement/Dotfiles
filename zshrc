# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

#shows dots if waiting for autocompletion, ...
COMPLETION_WAITING_DOTS="true"

# DISABLE AUTOCORRECTION
DISABLE_CORRECTION="true"

export TERM="xterm-256color"

if [ -f $HOME/.private_zshrc_begin ]; then
    source $HOME/.private_zshrc_begin
fi

#########################################antigen stuff####################################

source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

#specify bundles
antigen bundles <<EOBUNDLES

# Helper for extracting different types of archives
extract

#for working with git
voronkovich/gitignore.plugin.zsh

# to go to parent dirs quickly
Tarrasch/zsh-bd

#more autocompletion
zsh-users/zsh-completions src

# mercurial auto completion and shortcuts
mercurial

pip

EOBUNDLES
# TODO find way to add plugin based on version

antigen theme bhilburn/powerlevel9k powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(background_jobs virtualenv)
if [ -n "$SSH_CLIENT" ]; then
    POWERLEVEL9K_CONTEXT_TEMPLATE="@%m"
fi
# shorten all ancestor dir names
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

antigen apply


export SHELL=$(which zsh)

#use vim mode for zsh
bindkey -v
# Better searching in command mode
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search


if [ -f $HOME/.shared_shell ]; then
    source $HOME/.shared_shell
fi

if [ -f $HOME/.autocompletion_zsh ]; then
    source $HOME/.autocompletion_zsh
fi

#use history per tab and just merge after exit that shell
setopt APPEND_HISTORY

if [ -f $HOME/.private_zshrc ]; then
    source $HOME/.private_zshrc
fi
