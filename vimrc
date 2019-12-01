syntax on

set nocompatible
set fenc=utf-8
set autoread
set title
set number
set tabstop=4
set shiftwidth=4
"set smartindent
set cursorline
set mouse=a
set showmatch
set laststatus=2
set incsearch
set whichwrap=b,s,h,l,<,>,[,],~
set smarttab
set shiftround
set autoread

" whitespaces
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%

set statusline=%F%m\ %<[%{&fenc!=''?&fenc:&enc}]\ [%Y]\ [ln:%l,col:%v]

" .viminfo
set viminfo+=n~/.local/share/vim/viminfo

set hidden

" keymaps
inoremap jj <ESC>
nnoremap h gh
nnoremap j gj
nnoremap k gk
nnoremap l gl
