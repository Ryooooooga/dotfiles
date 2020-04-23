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

if dein#load_state($XDG_DATA_HOME . '/dein')
    call dein#begin($XDG_DATA_HOME . '/dein')

    call dein#add('Shougo/deoplete.nvim')
    let g:deoplete#enable_at_startup = 1

    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('Shougo/defx.nvim')
    call dein#add('kristijanhusak/defx-icons')
    call dein#add('jiangmiao/auto-pairs')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('scrooloose/nerdtree')
    call dein#add('ryanoasis/vim-devicons')
    call dein#add('editorconfig/editorconfig-vim')
    call dein#add('tpope/vim-fugitive')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('liuchengxu/vim-clap', { 'build': './install.sh' })
    call dein#add('connorholyday/vim-snazzy')
    call dein#add('preservim/nerdcommenter')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif

" colorscheme
colorscheme snazzy

" defx.vim
" Run pip3 install pynvim
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
        \ !defx#is_directory()
        \   ? defx#do_action('drop')
        \   : defx#do_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> o
        \ !defx#is_directory()
        \   ? defx#do_action('drop')
        \   : defx#is_opened_tree() ? defx#do_action('close_tree') : defx#do_action('open_tree_recursive')
    nnoremap <silent><buffer><expr> r    defx#do_action('redraw')
    nnoremap <silent><buffer><expr> d    defx#do_action('remove')
    nnoremap <silent><buffer><expr> c    defx#do_action('copy')
    nnoremap <silent><buffer><expr> p    defx#do_action('paste')
    nnoremap <silent><buffer><expr> m    defx#do_action('move')
    nnoremap <silent><buffer><expr> n    defx#do_action('new_file')
    nnoremap <silent><buffer><expr> N    defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> q    defx#do_action('quit')
endfunction

call defx#custom#option('_', {
    \   'columns': 'indent:icons:filename:type',
    \   'direction': 'topleft',
    \   'split': 'vertical',
    \   'winwidth': 32,
    \ })

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

" vim-clap
let g:clap_theme = 'material_design_dark'
let g:clap_layout = {
        \ 'width': '80%',
        \ 'height': '60%',
        \ 'row': '20%',
        \ 'col': '10%',
    \ }
" Run :call clap#installer#download_binary() or :call clap#installer#install_maple()

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'

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
nnoremap <silent><C-a> ^
nnoremap <silent><C-e> $
nnoremap <silent><C-\> :vsplit<CR>
nnoremap <silent><C-_> :split<CR>
nnoremap <silent><C-o> :Defx -toggle<CR>
nnoremap <silent><C-h> :bprev<CR>
nnoremap <silent><C-l> :bnext<CR>
nnoremap <silent><C-w> :bdelete<CR>
nnoremap <silent>//    :Clap blines<CR>
nnoremap <silent><C-p> :Clap filer<CR>
nmap     <silent><C-_> <Plug>NERDCommenterToggle
vmap     <silent><C-_> <Plug>NERDCommenterToggle
