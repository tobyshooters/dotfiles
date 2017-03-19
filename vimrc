" .vimrc
" Author: Cristobal Sciutto

" Plugin Setup {{{
" Vundle Setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'Raimondi/delimitMate'
Plugin 'pangloss/vim-javascript'
Plugin 'haya14busa/incsearch.vim'

" Vundle End 
call vundle#end()
filetype plugin indent on
" }}}
" Basic Settings {{{
colorscheme molokai
autocmd BufEnter * colorscheme molokai
syntax enable
let mapleader=","
set backspace=indent,eol,start
set mouse=a
set ignorecase
set smartcase
set number
set ruler
set showcmd
set wildmenu
set lazyredraw
set showmatch
set title
set visualbell
set laststatus=2
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P
" }}}
" General Mapping {{{
" Movement {{{
nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $
" }}}
" Split windows {{{
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>m <C-w>s<C-w>j
nnoremap <leader>d <C-w>q
" }}}
" Miscellaneous {{{
inoremap jk <esc>
nnoremap <leader>s :mksession<CR>
" }}}
" }}}
" Indentation {{{
set tabstop=4
set softtabstop=4
set expandtab
" }}}
" Visual Highlighting {{{
nnoremap gV `[v`] 
" }}}
" Folding {{{
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent
nnoremap <Space> za
" }}}
" Filetype Specific {{{
autocmd FileType vim set foldlevel=0
autocmd FileType vim set foldmethod=marker
" }}}
" Plugin Settings {{{
let g:airline_theme = 'powerlineish'
noremap <leader>ft :NERDTreeToggle<CR>
" }}}
