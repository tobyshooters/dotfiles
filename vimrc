" .vimrc
" Author: Cristobal Sciutto

" Plugin Setup {{{
" Vundle Setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'Raimondi/delimitMate'
Plugin 'pangloss/vim-javascript'
Plugin 'haya14busa/incsearch.vim'
Plugin 'guns/vim-clojure-static'
Plugin 'tpope/vim-fireplace'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'junegunn/vim-easy-align'
Plugin 'xolox/vim-easytags'
Plugin 'xolox/vim-misc'
Plugin 'leafgarland/typescript-vim'
Plugin 'Valloric/YouCompleteMe'

" Extras
Plugin 'johngrib/vim-game-code-break'

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
" Opening and closing splits
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>m <C-w>s<C-w>j
nnoremap <leader>d <C-w>q
" Moving through splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
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
" CtrlP {{{
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store|_build'
" }}}
" Others {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:airline_theme = 'powerlineish'
noremap <leader>ft :NERDTreeToggle<CR>
map <leader>rp :RainbowParenthesesToggleAll<CR>
" }}}
" }}}
