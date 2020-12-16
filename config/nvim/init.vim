""" Options """
set fenc=utf-8
set hidden
set autoread
" Indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set smarttab
set list
" Views
set title
set number
set termguicolors
set cursorline
set showmatch
set laststatus=2
" Controls
set mouse=a
set whichwrap=b,s,h,l,<,>,[,],~
" Search
set incsearch
set smartcase
set ignorecase

""" Keymaps """
inoremap jj <ESC>
nnoremap ;  :
nnoremap j  gj
nnoremap k  gk
nnoremap <down> gj
nnoremap <up>   gk
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap <silent><C-a> ^
nnoremap <silent><C-e> $
nnoremap <silent><C-\> :vsplit<CR>
nnoremap <silent><C-_> :split<CR>
nnoremap <silent><C-h> :bprev<CR>
nnoremap <silent><C-l> :bnext<CR>
nnoremap <silent><C-w> :bdelete<CR>

""" Filetype """
autocmd BufNewFile,BufRead .envrc   set filetype=sh

""" dein.vim """
set runtimepath+=$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim

if dein#load_state($XDG_DATA_HOME . '/dein')
    call dein#begin($XDG_DATA_HOME . '/dein')

    call dein#load_toml($XDG_CONFIG_HOME . '/nvim/dein.toml')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif
