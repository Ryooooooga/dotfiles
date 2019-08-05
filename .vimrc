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

" NeoBundle
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'scrooloose/nerdtree'
call neobundle#end()

filetype plugin indent on

NeoBundleCheck

" keymaps
inoremap jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap <silent><C-e> :NERDTreeToggle<CR>

nnoremap <C-w> :w<CR>
inoremap <C-w> <C-o>:w<CR>
