###This file contains the environment variables used by bash and zsh

# Functions to add a folder to the PATH environment variable:
# Both functions take 1 argument, namely the dir, which should be added.
# this function adds the dir to the begin, if the dir is not in PATH
__pathaddbegin() {
    if [ -d "$1" ] && [[ ":$PATH" != *":$1:"* ]];
    then
        PATH="$1${PATH:+":$PATH"}"
    fi
}
# add dir to end, if it is nowhere in PATH
__pathaddend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]];
    then
        PATH="$PATH:$1"
    fi
}


if [ -d "$HOME/bin" ] ; then
    __pathaddend $HOME/bin
fi

if [ -d "$HOME/.local/bin" ] ; then
    __pathaddend $HOME/.local/bin
fi

POETRY_HOME="$HOME/.poetry/bin"
if [ -d "$POETRY_HOME" ] ; then
    __pathaddend $POETRY_HOME
fi

export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT/bin" ] ; then
    __pathaddbegin $PYENV_ROOT/bin
    __pathaddbegin $PYENV_ROOT/shims
fi

if [ -f "$HOME/.cargo/env" ] ; then
    source $HOME/.cargo/env
fi

unset -f __pathaddbegin
unset -f __pathaddend

# ---------------------------------------------------------------------

export VISUAL=vim
export EDITOR="$VISUAL"

# ---------------------------------------------------------------------

export HISTIGNORE='*sudo -S*'

# ---------------------------------------------------------------------

export MAKE_PARALLELIZATION=8
