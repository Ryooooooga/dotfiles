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
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

set statusline=%F%m\ %<[%{&fenc!=''?&fenc:&enc}]\ [%Y]\ [ln:%l,col:%v]

" .viminfo
set viminfo+=n~/.local/share/vim/viminfo

" NeoBundle
set runtimepath+=~/.local/share/vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.local/share/vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'junegunn/fzf'
NeoBundle 'junegunn/fzf.vim'
call neobundle#end()

filetype plugin indent on

NeoBundleCheck

" vim-airline
set hidden
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='wombat'
let g:airline_symbols = {
            \ 'branch': "\uf418",
            \ 'dirty': "\u00b1",
            \ }

" keymaps
inoremap jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap <silent><C-e> :NERDTreeToggle<CR>
nnoremap <silent><C-h> :bprev<CR>
nnoremap <silent><C-l> :bnext<CR>
nnoremap <silent><C-w> :bdelete<CR>
nnoremap //            :BLines<CR>
nnoremap <silent><C-o> :Files<CR>
