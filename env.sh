# NOTE: only add the directory if it is nowhere in PATH
__path_append() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$PATH:$1"
  fi
}

__path_append "$HOME"/bin

__path_append "$HOME"/.local/bin

__path_append "$HOME"/.poetry/bin

__path_append "$HOME"/.fzf/bin

unset -f __path_append

CARGO_ENV="$HOME"/.cargo/env
if [ -f "$CARGO_ENV" ]; then
  # shellcheck source=/dev/null
  source "$CARGO_ENV"
fi

# ---------------------------------------------------------------------

export VISUAL=vim
export EDITOR="$VISUAL"

# ---------------------------------------------------------------------

export HISTIGNORE='*sudo -S*'

# ---------------------------------------------------------------------

export MAKE_PARALLELIZATION=8
