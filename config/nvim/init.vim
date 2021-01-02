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
set showtabline=2
set laststatus=2
" Controls
set mouse=a
set whichwrap=b,s,h,l,<,>,[,],~
" Search
set incsearch
set smartcase
set ignorecase
" Split
set splitbelow
set splitright
" Backspace
set backspace=indent,eol,start

""" Keymaps """
nnoremap ;      :
nnoremap j      gj
nnoremap k      gk
nnoremap <Down> gj
nnoremap <Up>   gk
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
inoremap jj     <ESC>
inoremap <Down> <C-\><C-o>gj
inoremap <Up>   <C-\><C-o>gk
inoremap <C-a>  <C-o>I
inoremap <C-e>  <End>
tnoremap <silent><ESC> <C-\><C-n>

""" Terminal """
source $XDG_CONFIG_HOME/nvim/terminal.vim

""" Filetype """
augroup vimrc
    autocmd!
    autocmd BufNewFile,BufRead .envrc   set filetype=sh
    autocmd BufNewFile,BufRead config   set filetype=gitconfig
augroup END

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

""" Highlight """
highlight BufferCurrentSign guifg=#5faefe
highlight BufferVisibleSign guifg=#7be4a4
highlight BufferInactive    guifg=#808080 guibg=#262626
highlight BufferTabpageFill guifg=#444444 guibg=#303030
highlight Scrollbar         guibg=#5e5e6a
