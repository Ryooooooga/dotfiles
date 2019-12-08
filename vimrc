syntax on

set nocompatible
set fenc=utf-8
set autoread
set title
set number
set tabstop=4
set shiftwidth=4
set cursorline
set mouse=a
set showmatch
set laststatus=2
set incsearch
set whichwrap=b,s,h,l,<,>,[,],~
set smarttab
set shiftround
set autoread
set smartcase
set ignorecase

" whitespaces
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%

set statusline=%F%m\ %<[%{&fenc!=''?&fenc:&enc}]\ [%Y]\ [ln:%l,col:%v]

" .viminfo
set viminfo+=n~/.local/share/vim/viminfo

set hidden

" keymaps
inoremap jj <ESC>
nnoremap ; :
nnoremap h gh
nnoremap j gj
nnoremap k gk
nnoremap l gl
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sH <C-w>H
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap <C-\> :vsplit<CR>
nnoremap <C-_> :split<CR>
