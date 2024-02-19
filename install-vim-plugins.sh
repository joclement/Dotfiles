#!/bin/bash

set -euo pipefail

pushd vim/pack/plugins/start/coc.nvim
yarn install --frozen-lockfile
popd

~/.fzf/install --no-bash --no-zsh
