#!/bin/bash

set -euo pipefail

echo "Install solarized"
./gnome-terminal-colors-solarized/install.sh \
  --scheme dark --profile solarized --skip-dircolors \
  || echo "WARNING: Failed to install solarized terminal colors"
