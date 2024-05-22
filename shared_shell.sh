# This file contains all the settings shared between different shells(bash, zsh)
# It just sources(enables) the other shared files, if they exist

source "$HOME"/.shared_aliases.sh
source "$HOME"/.env.sh

if [ -f "$HOME"/.private ]; then
    source "$HOME"/.private.sh
fi

eval $(dircolors ~/.dircolors-solarized/dircolors.ansi-dark)
