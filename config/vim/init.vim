syntax on

""" Options """
set fenc=utf-8
set hidden
set autoread
set showcmd
" Indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set smarttab
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
" Views
set title
set number
set cursorline
set showmatch
set laststatus=2
set statusline=%F%m\ %<[%{&fenc!=''?&fenc:&enc}]\ [%Y]\ [ln:%l,col:%v]
set showtabline=2
" Controls
set mouse=a
set whichwrap=b,s,h,l,<,>,[,],~
" Search
set hlsearch
set incsearch
set smartcase
set ignorecase
" Split
set splitbelow
set splitright
" Backspace
set backspace=indent,eol,start
" Menu
set wildmenu
set wildmode=longest:full,full

" .viminfo
set viminfo+=n~/.local/share/vim/viminfo

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
nnoremap <silent><C-h> :tabprev<CR>
nnoremap <silent><C-l> :tabnext<CR>
nnoremap <silent><C-w> :tabclose<CR>
inoremap jj     <ESC>
inoremap <Down> <C-\><C-o>gj
inoremap <Up>   <C-\><C-o>gk
inoremap <C-a>  <C-o>I
inoremap <C-e>  <End>

""" terminal """
command! -nargs=* T botright term <args>

augroup vimrc
    autocmd!
    autocmd VimEnter * if !&diff | tab all | tabfirst | endif
augroup END
