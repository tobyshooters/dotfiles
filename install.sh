#!bin/bash
cd ~
mv vimrc .vim
touch .vimrc
echo "source ~/.vim/vimrc" >> .vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
