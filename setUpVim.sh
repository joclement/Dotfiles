echo "install installation tools"
sudo apt-get install build-essential cmake python-dev

echo "install vim if missing"
sudo apt-get install vim

echo "Clone the Vundle repo"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "install vim add ons"
vim +PluginInstall +qall

echo "install YouCompleteMe if it is a addon"
if [ -f ~/.vim/bundle/YouCompleteMe/install.sh ]; then
	. ~/.vim/bundle/YouCompleteMe/install.sh
else 
	echo "YouCompleteMe has not been found"
fi
