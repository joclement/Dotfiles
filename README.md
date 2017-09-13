Dotfiles
========
This repository includes all of my custom Dotfiles.

This repository uses some of the content from github.com/michaeljsmalley/Dotfiles,
especially for linking the Dotfiles. I thank him for sharing his Dotfiles.

This Dotfiles repository focuses on:
* zsh using antigen
* vim
* solarized
* git
* own small functions and aliases to improve work

The used plugins can be changed very easily for vim and zsh because of the use
of antigen and Vundle. For more information on antigen and Vundle have a look in
their repositories.

If you've any questions, recommendations or criticism feel free to write me a mail.

### Requirements

These Dotfiles are used and have been tested on Ubuntu 14.04 and 16.04. They
should work on other Linux distributions without any changes as well.

These is no warranty or guarantee that they will work on your system. They have
been tested and are working on my system, but you should save your Dotfiles and
back up your system before installing these Dotfiles.

### Installation

The installation process is explained in detail in the file `install.sh` and you
can get some help information with `install.sh -h`.
The bash script relies on certain tools, which it will check for and install if
needed. Therefor it uses apt, which is just available on debian based systems.
So this script can not be used or has to be adapted for other distributions.

### Quick Installation

To be absolutely secure save your Dotfiles prior to doing this!

``` bash
git clone git://github.com/flyingdutchman23/Dotfiles ~/Dotfiles
cd ~/Dotfiles
./install.sh -i install
```
