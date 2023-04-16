[![Test](https://github.com/joclement/Dotfiles/workflows/Test/badge.svg)](https://github.com/joclement/Dotfiles/actions?workflow=Test)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/joclement/Dotfiles/master.svg)](https://results.pre-commit.ci/latest/github/joclement/Dotfiles/master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


Dotfiles
========
This repository includes all of my custom Dotfiles.

This Dotfiles repository focuses on:
* zsh using antigen
* vim using vim-plug for plugin management
* solarized
* git
* own small functions and aliases

If you've any questions, recommendations or criticism feel free to write me a mail.

### Requirements

These Dotfiles are used and most suited for Ubuntu 18.04, but they will
probably work on other Linux distributions as well.
The install file will only work on Ubuntu or other Debian based Systems
as it uses `apt` and `dpkg`.

### Installation

The installation process is explained in detail in the file `install.sh` and you
can get some help information with `install.sh -h`.
As described the installation will only work on Debian based Systems.

There is no warranty or guarantee that they will work on your system.
They have been tested and are working on my system, but you should save your
Dotfiles and/or back up your system before installing these Dotfiles.

### Quick Installation

To be secure save your Dotfiles prior to installing with this install script!

After cloning this repository to a suitable location like `~/Dotfiles` just run
`./install`.

### Licensing

Nearly all files in this project are licensed under [the MIT license](LICENSE).
The file [vim/autoload/plug.vim](vim/autoload/plug.vim) is also licensed under
the MIT license, but with a different copyright owner.
This does of course not apply to the used git submodules.
Furthermore, an exception is [install.sh](install.sh), which is licensed with
GPLv3 as it is based on
[this file](https://github.com/michaeljsmalley/dotfiles/blob/dfda5948f2afe3d7d2c9087b04b56f8e4918abd0/makesymlinks.sh).

### Acknowledgments

This repository used content from
[Michael Smalley's Dotfiles](https://github.com/michaeljsmalley/Dotfiles)
for linking the Dotfiles.
I thank him for sharing his Dotfiles.
