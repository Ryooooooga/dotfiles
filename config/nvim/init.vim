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

" dein.vim
set runtimepath+=$XDG_DATA_HOME/dein/repos/github.com/Shougo/dein.vim

if dein#load_state($XDG_DATA_HOME . '/dein')
    call dein#begin($XDG_DATA_HOME . '/dein')

    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('neovim/nvim-lsp')
    call dein#add('nvim-lua/completion-nvim')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('tpope/vim-fugitive')
    call dein#add('liuchengxu/vim-clap', { 'build': './install.sh' })
    call dein#add('terryma/vim-multiple-cursors')
    call dein#add('terryma/vim-expand-region')
    call dein#load_toml($XDG_CONFIG_HOME . '/nvim/dein.toml')

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif

" LSP and completions
set completeopt=menuone,noinsert
set shortmess+=c
let g:completion_enable_auto_popup = 1

lua require'nvim_lsp'.clangd.setup{ on_attach=require'completion'.on_attach }

nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-f> <cmd>lua vim.lsp.buf.formatting()<CR>

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
    nnoremap <silent><buffer><expr> h       defx#do_action('close_tree')
    nnoremap <silent><buffer><expr> l       defx#do_action('open_tree')
    nnoremap <silent><buffer><expr> <Left>  defx#do_action('close_tree')
    nnoremap <silent><buffer><expr> <Right> defx#do_action('open_tree')
    nnoremap <silent><buffer><expr> r       defx#do_action('redraw')
    nnoremap <silent><buffer><expr> d       defx#do_action('remove')
    nnoremap <silent><buffer><expr> c       defx#do_action('copy')
    nnoremap <silent><buffer><expr> p       defx#do_action('paste')
    nnoremap <silent><buffer><expr> m       defx#do_action('move')
    nnoremap <silent><buffer><expr> n       defx#do_action('new_file')
    nnoremap <silent><buffer><expr> N       defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> q       defx#do_action('quit')
    nnoremap <silent><buffer><expr> .       defx#do_action('toggle_ignored_files')
endfunction

call defx#custom#option('_', {
    \   'columns': 'space:indent:git:icons:filename:type',
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

" vim-clap
let g:clap_theme = 'material_design_dark'
let g:clap_layout = {
        \ 'width': '80%',
        \ 'height': '60%',
        \ 'row': '20%',
        \ 'col': '10%',
    \ }
" Run :call clap#installer#download_binary() or :call clap#installer#install_maple()

" multiple-cursors
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key      = '<C-d>'
let g:multi_cursor_select_all_word_key = 'A<C-d>'
let g:multi_cursor_start_key           = 'g<C-d>'
let g:multi_cursor_select_all_key      = 'gA<C-d>'
let g:multi_cursor_next_key            = '<C-d>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-k>'
let g:multi_cursor_quit_key            = '<Esc>'

" keymaps
nnoremap <silent><C-o> :Defx -toggle -show-ignored-files<CR>
nnoremap <silent>//    :Clap blines<CR>
nnoremap <silent><C-p> :Clap filer<CR>
vmap     v             <Plug>(expand_region_expand)
vmap     V             <Plug>(expand_region_shrink)
