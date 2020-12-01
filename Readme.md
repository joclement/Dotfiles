[![Build Status](https://travis-ci.org/flyingdutchman23/Dotfiles.svg?branch=master)](https://travis-ci.org/flyingdutchman23/Dotfiles)

Dotfiles
========
This repository includes all of my custom Dotfiles.

This Dotfiles repository focuses on:
* zsh using antigen
* vim using vim-plug for plugin management
* solarized
* git, mercurial
* own small functions and aliases

If you've any questions, recommendations or criticism feel free to write me a mail.

### Requirements

These Dotfiles are used and most suited for Ubuntu 18.04, but they will
probably work on other Linux distributions as well.
Mainly the install file will only work on Ubuntu or other Debian based Systems
as it uses `apt` and `dpkg`.

### Installation

The installation process is explained in detail in the file `install.sh` and you
can get some help information with `install.sh -h`.
As described the installation will only work on Debian based Systems.

There is no warranty or guarantee that they will work on your system.
They have been tested and are working on my system, but you should save your
Dotfiles and/or back up your system before installing these Dotfiles.

### Quick Installation

To be absolutely secure save your Dotfiles prior to doing this!

``` bash
git clone git://github.com/flyingdutchman23/Dotfiles ~/Dotfiles
cd ~/Dotfiles
./install.sh -i install
```

### Acknowledgments

This repository used content from
[Michael Smalley's Dotfiles](https://github.com/michaeljsmalley/Dotfiles)
for linking the Dotfiles.
I thank him for sharing his Dotfiles.
