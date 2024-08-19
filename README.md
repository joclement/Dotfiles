[![Test](https://github.com/joclement/Dotfiles/workflows/Test/badge.svg)](
  https://github.com/joclement/Dotfiles/actions?workflow=Test)
[![pre-commit.ci status](
  https://results.pre-commit.ci/badge/github/joclement/Dotfiles/master.svg)](
  https://results.pre-commit.ci/latest/github/joclement/Dotfiles/master)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](
  https://opensource.org/licenses/MIT)


Dotfiles
========
This repository includes my custom Dotfiles.

This Dotfiles repository focuses on:
* zsh using antigen
* vim using the built-in plugin manager pack for plugin management
* solarized
* git
* own small functions and aliases

### Requirements

I use these Dotfiles with Ubuntu. As most files are OS-agnostic these would work
on other operating systems as well.
As `apt` and `snap` are used the installation will only work on Ubuntu.

### Installation

This repository makes use of [dotbot](https://github.com/anishathalye/dotbot)
to link the dotfiles and install software.

There is no warranty or guarantee that they will work on your system.
They have been tested and are working on my system, but you should save your
Dotfiles and/or back up your system before installing these Dotfiles.

After cloning this repository to a suitable location like `~/Dotfiles` just run
`./install.sh`.

### Licensing

Nearly all files in this project are licensed under
[the MIT license](LICENSE.md).
Exceptions are the used submodules.

### Acknowledgments

This repository used content from
[Michael Smalley's Dotfiles](https://github.com/michaeljsmalley/Dotfiles)
for linking the Dotfiles.
I thank him for sharing his Dotfiles.
