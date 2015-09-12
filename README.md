Dotfiles
========
This repository includes all of my custom dotfiles.

This repository uses some of the content from github.com/michaeljsmalley/dotfiles,
especially for linking the dotfiles.

They should be cloned to your home directory so that the path is `~/Dotfiles/`.  
The included setup script creates symlinks from your home directory to the files which are located
in `~/Dotfiles/`.

The setup script is smart enough to back up your existing dotfiles into a
`~/Dotfiles_old/` directory if you already have any dotfiles of the same name as
the dotfile symlinks being created in your home directory.

I also prefer `zsh` as my shell of choice.  As such, the setup script will also
clone the `oh-my-zsh` repository from my GitHub. It then checks to see if `zsh`
is installed.  If `zsh` is installed, and it is not already configured as the
default shell, the setup script will execute a `chsh -s $(which zsh)`.  This
changes the default shell to zsh, and takes effect as soon as a new zsh is
spawned or on next login.

So, to recap, the install script will:

1. install all needed dependencies for a ubuntu operating system. For others it will exit.
2. Back up any existing dotfiles in your home directory to `~/dotfiles_old/`
3. Clone the `oh-my-zsh` repository from my GitHub (for use with `zsh`)
4. Check to see if `zsh` is installed, if it isn't, try to install it.
5. If zsh is installed, run a `chsh -s` to set it as the default shell.
6. Create symlinks to the dotfiles in `~/Dotfiles/` in your home directory
7. install Vundle as a vim plugin manager, install the add-ons mentioned in vimrc
and if present compile YouCompleteMe

Installation
------------

``` bash
git clone git://github.com/flyingdutchman23/Dotfiles ~/Dotfiles
cd ~/Dotfiles
./install.sh
```
