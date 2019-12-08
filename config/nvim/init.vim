if &compatible
    set nocompatible
endif

set fenc=utf-8
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
set smartcase
set ignorecase
set shiftround
set hidden
set autoread

" whitespaces
set list

" dein.vim
set runtimepath+=$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim
set runtimepath+=$XDG_DATA_HOME/dein/repos/github.com/junegunn/fzf

if dein#load_state($XDG_DATA_HOME . '/dein')
    call dein#begin($XDG_DATA_HOME . '/dein')

    call dein#add('Shougo/deoplete.nvim')
    let g:deoplete#enable_at_startup = 1

    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('jiangmiao/auto-pairs')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('scrooloose/nerdtree')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('tpope/vim-fugitive')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('junegunn/fzf', { 'rtp': '' })
    call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif

" neosnippet
let g:neosnippet#snippets_directory=$XDG_CONFIG_HOME . '/nvim/snippets'

imap <C-k>       <Plug>(neosnippet_expand_or_jump)
smap <C-k>       <Plug>(neosnippet_expand_or_jump)
xmap <C-k>       <Plug>(neosnippet_expand_target)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

if has('conceal')
    set conceallevel=2 concealcursor=niv
endif

" vim-airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='wombat'
let g:airline_symbols = {
        \ 'branch': "\uf418",
        \ 'dirty': "\u00b1",
    \ }

" keymaps
inoremap jj <ESC>
nnoremap ;  :
nnoremap h  gh
nnoremap j  gj
nnoremap k  gk
nnoremap l  gl
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
nnoremap <silent><C-e> :NERDTreeToggle<CR>
nnoremap <silent><C-h> :bprev<CR>
nnoremap <silent><C-l> :bnext<CR>
nnoremap <silent><C-w> :bdelete<CR>
nnoremap //            :BLine<CR>
nnoremap <silent><C-o> :Files<CR>
