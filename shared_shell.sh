# This file contains all the settings shared between different shells(bash, zsh)

# shellcheck source=shared_shell.sh
source "$HOME"/.shared_aliases.sh
# shellcheck source=env.sh
source "$HOME"/.env.sh

if [ -f "$HOME"/.private.sh ]; then
    # shellcheck source=/dev/null
    source "$HOME"/.private.sh
fi

eval "$(dircolors ~/.dircolors-solarized/dircolors.ansi-dark)"
