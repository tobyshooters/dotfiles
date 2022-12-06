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
set laststatus=2
set conceallevel=2
set scrolloff=10

" }}}
" Color {{{

function! PatchColors()
    highlight LineNr ctermfg=grey
    highlight VertSplit ctermfg=250
    highlight Folded ctermbg=255
    highlight NonText ctermfg=grey
    highlight Visual cterm=None ctermbg=LightYellow
    highlight StatusLine cterm=None ctermfg=235 ctermbg=252
    highlight StatusLineNC cterm=None ctermfg=254 ctermbg=252
endfunction

autocmd BufEnter * call PatchColors()

" }}}
" Status Bar {{{
let g:currentmode={
   \ 'n':      'NORMAL',
   \ 'v':      'VISUAL',
   \ 'V':      'VISUAL',
   \ "\<C-V>": 'VISUAL',
   \ 'i':      'INSERT',
   \ 'R':      'R',
   \ 'Rv':     'V·REPLACE',
   \ 'c':      'COMMAND',
\}

function WordCount()
    if has_key(wordcount(), 'visual_words')
        return wordcount().visual_words." of ".wordcount().words
    else
        return wordcount().words
    endif
endfunction

set statusline=
set statusline+=\ %-8(%{g:currentmode[mode()]}%) "mode
set statusline+=%{&paste?'PASTE\ ':''}           "paste mode
set statusline+=%{expand('%:~:.')}               "filepath
set statusline+=\ %y                             "filetype
set statusline+=\ %m                             "file is modified
set statusline+=%=                               "padding
set statusline+=\ %5(%{WordCount()}\ words%)     "word count
set statusline+=\ %5(%L\ lines%)                "line count

" }}}
" Movement and Splits {{{

nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $
map q: <Nop>
nnoremap Q <nop>

" Allows scrolling through autocomplete with j and k
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

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
set showbreak=↪\

autocmd Filetype javascript setlocal ts=2 sw=2 sts=0
au BufRead,BufNewFile *.ts set filetype=javascript
au BufRead,BufNewFile *.tsx set filetype=javascript
au BufRead,BufNewFile *.jsx set filetype=javascript

" Folding
set foldenable
set foldnestmax=2
set foldmethod=indent
vnoremap <Space> zf
nnoremap <Space> za

autocmd FileType vim set foldmethod=marker

" }}}
" Copy and Paste {{{

set pastetoggle=<leader>p 
set clipboard=unnamed
noremap Y "+y

" }}}

" Makefiles {{{

:let &makeprg = 'if [ -f Makefile ]; then make Release && make RunRelease; else make Release -C .. && make RunRelease -C ..; fi'

"}}}

" Miscellaneous {{{
autocmd Filetype text setlocal spell
autocmd Filetype text set textwidth=79
autocmd Filetype markdown setlocal spell
autocmd Filetype markdown set textwidth=79

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

" Open Frameworks
:let &makeprg = 'if [ -f Makefile ]; then make Release && make RunRelease; else make Release -C .. && make RunRelease -C ..; fi'

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
noremap <leader>ft :NERDTreeToggle<CR>

" File search with <C-p>
Plugin 'kien/ctrlp.vim'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store|_build|public'

" Line search with Ack
Plugin 'mileszs/ack.vim'
map <leader>a :LAck!<Space>

" Better search highlighting
Plugin 'haya14busa/incsearch.vim'
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Align elements by spacing
Plugin 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Vim Wiki
Plugin 'vimwiki/vimwiki'
let g:vimwiki_list = [{
    \ 'path': '~/ideaspace/notes',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
    \ 'auto_diary_index': 1
\ }]
au BufNewFile ~/ideaspace/notes/diary/*.md :silent 0r !~/ideaspace/notes/diary/diary_template.py '%'

" Focus and type-writer mode
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
noremap <leader>g :Goyo <bar> highlight StatusLineNC ctermfg=grey <CR>
let g:goyo_height='80%'

autocmd! User GoyoEnter Limelight  | set scrolloff=999
autocmd! User GoyoLeave Limelight! | set scrolloff=10
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_paragraph_span = 1

" Style
Plugin 'nvie/vim-flake8'
autocmd BufWritePost *.py call flake8#Flake8()

Plugin 'eslint/eslint'

" Others
Plugin 'tpope/vim-surround'       " Edit surrounding elements
Plugin 'tpope/vim-commentary'     " Comment lines easily
Plugin 'tpope/vim-repeat'         " Use . for plugin commands
Plugin 'Raimondi/delimitMate'     " Auto complete for delimitrs
Plugin 'othree/html5.vim'         " HTML syntax

" Vundle End
call vundle#end()
filetype plugin indent on

" }}}
