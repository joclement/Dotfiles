# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
P10K_INSTANT_PROMPT="${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
if [[ -r "$P10K_INSTANT_PROMPT" ]]; then
  source "$P10K_INSTANT_PROMPT"
fi

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

#shows dots if waiting for autocompletion, ...
COMPLETION_WAITING_DOTS="true"

# DISABLE AUTOCORRECTION
DISABLE_CORRECTION="true"

export TERM="xterm-256color"

if [ -f "$HOME"/.private_zshrc_begin ]; then
    source "$HOME"/.private_zshrc_begin
fi

# for custom autocompletion
fpath+=$HOME/.zfunc

###############################antigen stuff####################################

source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

#specify bundles
antigen bundles <<EOBUNDLES

#for working with git
voronkovich/gitignore.plugin.zsh

# to go to parent dirs quickly
Tarrasch/zsh-bd

#more autocompletion
zsh-users/zsh-completions src

pip

EOBUNDLES
# TODO find way to add plugin based on version

antigen theme romkatv/powerlevel10k

antigen apply

##############################Further config####################################

export SHELL=$(which zsh)

#use vim mode for zsh
bindkey -v
# Better searching in command mode
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search


source "$HOME"/.shared_shell.sh
source "$HOME"/.autocompletion.zsh

#use history per tab and just merge after exit that shell
setopt APPEND_HISTORY

export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

#allow to open editor for a command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

source "$HOME"/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# pip autocomplete
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 "$words"[1] 2>/dev/null ))
}
compctl -K _pip_completion pip

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
