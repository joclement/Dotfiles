#!/bin/bash

set -euo pipefail

sudo apt-get install -y \
    build-essential \
    curl \
    dconf-cli

# editorconfig-checker-disable
curl --verbose --silent --fail --show-error \
    https://raw.githubusercontent.com/nodesource/distributions/66d777ee3fb7748b1c4b7d1d52511e6194fcda06/deb/setup_18.x \
    --output /tmp/nodesource_setup.sh
# editorconfig-checker-enable
sudo bash /tmp/nodesource_setup.sh
sudo apt-get install --yes nodejs
