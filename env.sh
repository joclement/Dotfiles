# shellcheck shell=bash

__path_append_if_dir_exists() {
  if [[ -d $1 ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$PATH:$1"
  fi
}

__path_append_if_dir_exists "$HOME"/bin

__path_append_if_dir_exists "$HOME"/.local/bin

__path_append_if_dir_exists "$HOME"/.poetry/bin

__path_append_if_dir_exists "$HOME"/.fzf/bin

__path_append_if_dir_exists "$HOME"/go/bin

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

# ---------------------------------------------------------------------

FZF_SKIP_DIRS=(
  .git
  .mypy_cache
  .nox
  .pytest_cache
  .tox
  .venv
  __pycache__
  build
)
FZF_DEFAULT_OPTS="--walker-skip=$(
  IFS=,
  echo "${FZF_SKIP_DIRS[*]}"
)"
export FZF_DEFAULT_OPTS
