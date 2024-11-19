# NOTE: only add the directory if it is nowhere in PATH
__path_add_end() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

if [ -d "$HOME/bin" ]; then
    __path_add_end "$HOME"/bin
fi

if [ -d "$HOME/.local/bin" ]; then
    __path_add_end "$HOME"/.local/bin
fi

POETRY_HOME="$HOME/.poetry/bin"
if [ -d "$POETRY_HOME" ]; then
    __path_add_end "$POETRY_HOME"
fi

if [ -f "$HOME/.cargo/env" ]; then
    # shellcheck source=/dev/null
    source "$HOME"/.cargo/env
fi

unset -f __path_add_end

# ---------------------------------------------------------------------

export VISUAL=vim
export EDITOR="$VISUAL"

# ---------------------------------------------------------------------

export HISTIGNORE='*sudo -S*'

# ---------------------------------------------------------------------

export MAKE_PARALLELIZATION=8
