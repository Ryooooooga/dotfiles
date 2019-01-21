syntax on

set nocompatible
set fenc=utf-8
set autoread
set title
set number
set tabstop=4
"set smartindent
set cursorline
set showmatch
set laststatus=2
set incsearch
set whichwrap=b,s,h,l,<,>,[,],~

set statusline=%F%m[ln:%l,col:%v]

inoremap jj <ESC>
nnoremap j gj
nnoremap k gk

nnoremap <C-w> :w<CR>
inoremap <C-w> <C-o>:w<CR>
