#!/bin/bash

set -euo pipefail

sudo apt-get purge --yes nodejs
sudo rm -f /etc/apt/sources.list.d/nodesource.list

echo "Install Node.js"
sudo snap install --classic node
