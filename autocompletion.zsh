#This file is to improve the autocompletion for the zsh shell

# editorconfig-checker-disable

#restrict autocompletion for vim
#do not autcomplete the named filetypes
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
