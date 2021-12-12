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

function! PatchColors()
    highlight LineNr ctermfg=grey
    highlight VertSplit ctermfg=250
    highlight Folded ctermbg=255
    highlight NonText ctermfg=grey
    highlight Visual cterm=None ctermbg=LightYellow
    highlight StatusLine ctermfg=250 ctermbg=255
    highlight StatusLineNC ctermfg=250 ctermbg=255
endfunction

autocmd BufEnter * call PatchColors()

" }}}
" Status Bar {{{
let g:currentmode={
   \ 'n':      'NORMAL',
   \ 'v':      'VISUAL',
   \ 'V':      'V·LINE',
   \ "\<C-V>": 'V·BLOCK',
   \ 'i':      'INSERT',
   \ 'R':      'R',
   \ 'Rv':     'V·REPLACE',
   \ 'c':      'COMMAND',
\}
set statusline=
set statusline+=\ %-7(%{g:currentmode[mode()]}%)
set statusline+=\ %F

set statusline+=%=
set statusline+=\ %5(%lL%)
set statusline+=\ %5(%{wordcount().words}\ words%)

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
set foldnestmax=2
set foldmethod=indent
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
set rtp+=~/dotfiles/bundle/Vundle.vim
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
" Use . for plugin commands
Plugin 'tpope/vim-repeat'
" Align elements by spacing
Plugin 'junegunn/vim-easy-align'
" Auto complete for delimitrs
Plugin 'Raimondi/delimitMate'

" Note-taking
Plugin 'vimwiki/vimwiki'
Plugin 'plasticboy/vim-markdown'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'

" Syntax
Plugin 'othree/html5.vim'

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

" Go Yo and Lime Light
noremap <leader>g :Goyo <bar> highlight StatusLineNC ctermfg=grey <CR>
let g:goyo_height='80%'
autocmd! User GoyoEnter Limelight  | set scrolloff=999
autocmd! User GoyoLeave Limelight! | set scrolloff=0
let g:limelight_conceal_ctermfg = 'gray'

" Vim Wiki
let g:vimwiki_list = [{
            \ 'path': '~/ideaspace/notes', 
            \ 'syntax': 'markdown', 
            \ 'ext': '.md', 
            \ 'auto_diary_index': 1
            \ }]

" Vim Medieval
let g:medieval_langs = ['python=python3', 'sh', 'console=bash']
nnoremap <leader>E :<C-U>EvalBlock<CR>
" }}}
