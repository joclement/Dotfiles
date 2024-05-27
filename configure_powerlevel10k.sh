#!/bin/bash

set -euo pipefail

if [[ ! -f "$HOME/.p10k.zsh" && $- == *i* ]]; then
    p10k configure
fi
