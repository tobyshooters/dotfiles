csciutto's vimfiles

These are my custom vim files with my basic settings and plugins
Stored on Git for easy initialization on new machines

Pre-installed `vundle` plugins
- Ctrl P
- Nerdtree
- delimitMate
- Fireplace REPL
- Surround
- EasyAlign
- and others...

To setup in your own terminal, run the following commands:
1. `git clone https://github.com/csciutto/vimrc.git`
2. `mv vimrc .vim`
3. `touch .vimrc`
4. `echo "source ~/.vim/vimrc" >> .vimrc`
5. `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
6. `vim +PluginInstall +qall`
