#This file is to improve the autocompletion for the zsh shell

autoload -U compinit; compinit

# editorconfig-checker-disable

# do not autocomplete the named filetypes for vim
zstyle ':completion:*:*:vim:*' \
       file-patterns \
       '^*.(class|zip|doc|aux|xls|fls|blg|fdb_latexmk|eps|log|pdf|jpeg|png|ods|bbl|h5|jpg|swp|class|obj|obj|o|a|toc):source-files' \
       '*:all-files'

# editorconfig-checker-enable

zstyle ':completion:*:*:op:*' \
       file-patterns \
       '^*.(md|cpp|hpp|java|py):source-files' \
       '*:all-files'

zstyle ':completion:*:*:md2html:*' file-patterns '*.md'
zstyle ':completion:*:*:markdown:*' file-patterns '*.md'


function _pip_completion {
  local words cword
  # shellcheck disable=SC2162
  read -Ac words
  # shellcheck disable=SC2162
  read -cn cword
  # shellcheck disable=SC1087,SC2034,SC2207,SC2211
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 "$words"[1] 2>/dev/null ))
}
compctl -K _pip_completion pip

if [ -x "$(command -v glab)" ]; then
    # shellcheck source=/dev/null
    source <(glab completion -s zsh)
    compdef _glab glab
fi
