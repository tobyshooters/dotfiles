" vimrc
" Author: Cristobal Sciutto

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
set ruler
set laststatus=2
set conceallevel=2

" }}}
" Color {{{

let g:airline_theme = 'silver'
highlight LineNr ctermfg=grey
highlight VertSplit ctermfg=grey
highlight NonText ctermfg=grey

" }}}
" Type {{{

set showbreak=↪\

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
" Copy and Paste {{{

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
" Filetype Specific {{{
autocmd FileType vim set foldlevel=0
autocmd FileType vim set foldmethod=marker

autocmd Filetype javascript setlocal ts=2 sw=2 sts=0
au BufRead,BufNewFile *.ts set filetype=javascript
au BufRead,BufNewFile *.tsx set filetype=javascript
au BufRead,BufNewFile *.jsx set filetype=javascript

autocmd Filetype text set textwidth=79
autocmd Filetype text setlocal spell

autocmd Filetype markdown set textwidth=79
autocmd Filetype markdown setlocal spell
" }}}

" Plugin Setup {{{

" Vundle Setup
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" File Tree with <Leader>ft
Plugin 'scrooloose/nerdtree'
" Tag Bar
Plugin 'preservim/tagbar'
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

" Minimalist writing mode
Plugin 'junegunn/goyo.vim'

" Note-taking
Plugin 'vimwiki/vimwiki'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Vundle End 
call vundle#end()
filetype plugin indent on

" }}}
" Plugin Settings {{{

" Ctrl-P
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store|_build|public'

" To use Ack
map <leader>a :LAck!<Space>
" Visually selected ack
vnoremap <leader>a y:Ack <C-r>=fnameescape(@")<CR><CR>
" Find under cursor
noremap <leader>f :LAck! <cword><CR>

" Search
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Align tabular
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" File management
noremap <leader>ft :NERDTreeToggle<CR>
noremap <leader>t :TagbarToggle<CR>

" Go Yo
noremap <leader>g :Goyo <bar> highlight StatusLineNC ctermfg=grey <CR>
let g:goyo_height='80%'

" Vim Wiki
let g:vimwiki_list = [{'path': '~/Desktop/ideaspace/notes', 'syntax': 'markdown', 'ext': '.md'}]

" }}}
