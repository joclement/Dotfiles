# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
P10K_INSTANT_PROMPT="${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
if [[ -r "$P10K_INSTANT_PROMPT" ]]; then
  source "$P10K_INSTANT_PROMPT"
fi

# For completion
CASE_SENSITIVE="true"

COMPLETION_WAITING_DOTS="true"

DISABLE_CORRECTION="true"

export TERM="xterm-256color"

if [ -f "$HOME"/.private_zshrc_begin ]; then
    source "$HOME"/.private_zshrc_begin
fi

###############################antigen stuff####################################

source ~/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundles <<EOBUNDLES

voronkovich/gitignore.plugin.zsh

# to go to parent dirs quickly
Tarrasch/zsh-bd

# more autocompletion
zsh-users/zsh-completions src

pip

EOBUNDLES
# TODO find way to add plugin based on version

antigen theme romkatv/powerlevel10k

antigen apply

##############################Further config####################################

# use vim mode
bindkey -v
# Better searching in command mode
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
# Use regex for searching
bindkey '^R' history-incremental-pattern-search-backward


source "$HOME"/.shared_shell.sh
source "$HOME"/.autocompletion.zsh

setopt APPEND_HISTORY
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

# allow to open editor for a command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

source "$HOME"/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# for autocomplete
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 "$words"[1] 2>/dev/null ))
}
compctl -K _pip_completion pip

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
