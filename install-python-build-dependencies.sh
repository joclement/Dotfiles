#!/bin/bash

set -euo pipefail

echo "Install pyenv dependencies"

sudo apt-get install --yes \
    build-essential \
    curl \
    git \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev

os_version=$(lsb_release -sr)
if [[ $os_version == "24.04" ]]; then
    # TODO address problem after upgrading to 24.04
    echo \
        "ERROR: Installing all Python build dependencies fails" \
        " in Github Actions for Ubuntu 24.04"
else
    sudo apt-get install --yes \
        libssl-dev \
        libxml2-dev \
        libxmlsec1-dev \
        tk-dev \
        xz-utils \
        zlib1g-dev
fi
