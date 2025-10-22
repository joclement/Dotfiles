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

if [ -x "$(command -v glab)" ]; then
    # shellcheck source=/dev/null
    source <(glab completion -s zsh)
    compdef _glab glab
fi
