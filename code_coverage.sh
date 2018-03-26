#!/bin/bash

sudo apt-get install -y libcurl4-openssl-dev libelf-dev libdw-dev cmake \
                    wget curl zlib1g-dev build-essential pkg-config python

echo "wget kcov"
wget https://github.com/SimonKagstrom/kcov/archive/master.tar.gz &&
    echo "done wget" &&
    tar xzf master.tar.gz &&
    cd kcov-master &&
    mkdir build && cd build &&
    cmake .. && make && sudo make install &&
    cd ../.. &&
    rm -rf kcov-master &&
    mkdir -p coverage &&
    kcov coverage ./install.sh -i install -n -o &&
    bash <(curl -s https://codecov.io/bash)

