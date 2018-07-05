" vimrc
" Author: Cristobal Sciutto

" Plugin Setup {{{
" Vundle Setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" File Tree with <Leader>ft
Plugin 'scrooloose/nerdtree'
" File search with <C-p>
Plugin 'kien/ctrlp.vim'
" Better search highlighting
Plugin 'haya14busa/incsearch.vim'
" Status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Edit surrounding elements of text objects
Plugin 'tpope/vim-surround'
" Comment lines easily
Plugin 'tpope/vim-commentary'
" Use . for plugin commands
Plugin 'tpope/vim-repeat'
" Align elements by spacing
Plugin 'junegunn/vim-easy-align'
" Auto complete for delimitrs
Plugin 'Raimondi/delimitMate'
" Clojure pseudo-REPL
Plugin 'tpope/vim-fireplace'
" Ruby + Rails
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
" Ack
Plugin 'mileszs/ack.vim'

" Filetype Highlighting
Plugin 'leafgarland/typescript-vim'
Plugin 'mxw/vim-jsx'
Plugin 'pangloss/vim-javascript'
Plugin 'guns/vim-clojure-static'
Plugin 'toyamarinyon/vim-swift'
Plugin 'kchmck/vim-coffee-script'

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
" Allows copying and pasting
set clipboard=unnamed 
map q: <Nop>
nnoremap Q <nop>
" Allows scrolling through autocomplete with j and k
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))
" }}}
" }}}
" Indentation {{{
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
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
autocmd Filetype javascript setlocal ts=2 sw=2 sts=0
autocmd Filetype typescript setlocal ts=2 sw=2 sts=0
autocmd Filetype ruby setlocal ts=2 sw=2 sts=0
" }}}
" Plugin Settings {{{
" CtrlP {{{
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store|_build|public'
" }}}
" Ack {{{
map <leader>a :LAck!<Space>

" }}}
" Search {{{
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" }}}
" Others {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:airline_theme = 'powerlineish'
noremap <leader>ft :NERDTreeToggle<CR>
" }}}
" }}}
