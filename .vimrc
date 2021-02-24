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
" Line search with Ack
Plugin 'mileszs/ack.vim'

" Better search highlighting
Plugin 'haya14busa/incsearch.vim'
" Edit surrounding elements of text objects
Plugin 'tpope/vim-surround'
" Comment lines easily
Plugin 'tpope/vim-commentary'
" Align elements by spacing
Plugin 'junegunn/vim-easy-align'
" Auto complete for delimitrs
Plugin 'Raimondi/delimitMate'

" Use . for plugin commands
Plugin 'tpope/vim-repeat'
" Status bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Vundle End 
call vundle#end()
filetype plugin indent on

" }}}
" Basic Settings {{{

syntax enable
let mapleader=","
set nocompatible
set backspace=indent,eol,start
set mouse=a
set ignorecase
set smartcase
set number
set showcmd
set wildmenu
set lazyredraw
set showmatch
set title
set visualbell
set noruler
set laststatus=2

" }}}
" Airline Status Bar {{{

let g:airline_theme = 'monochrome'

" }}}
" Movement {{{

nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $

" Allows scrolling through autocomplete with j and k
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

" }}}
" Split windows {{{

" Opening and closing splits
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>m <C-w>s<C-w>j
nnoremap <leader>d <C-w>q
nnoremap <leader>= <C-w>=
" Moving through splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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
set foldmethod=manual
vnoremap <Space> zf
nnoremap <Space> za

" }}}
" Copy and Past {{{

set pastetoggle=<leader>p 
set clipboard=unnamed 
map q: <Nop>
nnoremap Q <nop>

" }}}
" Miscellaneous {{{

" Set the title of the Terminal to the currently open file
function! SetTerminalTitle()
    let titleString = expand('%:t')
    if len(titleString) > 0
        let &titlestring = expand('%:t')
        " this is the format iTerm2 expects when setting the window title
        let args = "\033];".&titlestring."\007"
        let cmd = 'silent !echo -e "'.args.'"'
        execute cmd
        redraw!
    endif
endfunction

autocmd BufEnter * call SetTerminalTitle()

" }}}
" Plugin Settings {{{
" CtrlP {{{
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store|_build|public'
" }}}
" Ack {{{
" To use Ack
map <leader>a :LAck!<Space>
" Visually selected ack
vnoremap <leader>a y:Ack <C-r>=fnameescape(@")<CR><CR>
" Find under cursor
noremap <leader>f :LAck! <cword><CR>
" }}}
" Search {{{
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
" }}}
" Others {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
noremap <leader>ft :NERDTreeToggle<CR>
" }}}
" }}}
" Filetype Specific {{{
autocmd FileType vim set foldlevel=0
autocmd FileType vim set foldmethod=marker
autocmd Filetype javascript setlocal ts=2 sw=2 sts=0
autocmd Filetype typescript setlocal ts=2 sw=2 sts=0
autocmd Filetype ruby setlocal ts=2 sw=2 sts=0
autocmd Filetype clojure setlocal sw=2 sts=2
autocmd Filetype text set textwidth=79
autocmd Filetype text setlocal spell
autocmd Filetype markdown set textwidth=79
autocmd Filetype markdown setlocal spell
" }}}
