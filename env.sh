# NOTE: only add the directory if it is nowhere in PATH
__pathaddend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

if [ -d "$HOME/bin" ]; then
    __pathaddend "$HOME"/bin
fi

if [ -d "$HOME/.local/bin" ]; then
    __pathaddend "$HOME"/.local/bin
fi

POETRY_HOME="$HOME/.poetry/bin"
if [ -d "$POETRY_HOME" ]; then
    __pathaddend "$POETRY_HOME"
fi

if [ -f "$HOME/.cargo/env" ]; then
    # shellcheck source=/dev/null
    source "$HOME"/.cargo/env
fi

unset -f __pathaddend

# ---------------------------------------------------------------------

export VISUAL=vim
export EDITOR="$VISUAL"

# ---------------------------------------------------------------------

export HISTIGNORE='*sudo -S*'

# ---------------------------------------------------------------------

export MAKE_PARALLELIZATION=8
