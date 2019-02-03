"--------------------------------------------------"
" Author:       Elisha Hastings                    "
" Homepage:     http://muckypupcreations.com       "
" Source:       http://github.com/tshakah/dotfiles "
"--------------------------------------------------"

" vim doesn't like fish :(
if &shell =~# 'fish$'
    set shell=zsh
endif

" vimconf is not vi-compatible
set nocompatible

let mapleader="\<SPACE>"

" Automatically make needed files and folders on first run
call system("mkdir -p $HOME/.config/nvim/{swap,undo}")

"---------"
" Plugins "
"---------"
call plug#begin("~/.config/nvim/plugged")


" Autocompletion
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
"let g:LanguageClient_serverCommands = {
"    \ 'elixir': ['/home/elishahastings/source/tools/elixir-ls/lsp/language_server.sh'],
"    \ }
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <F7> :call LanguageClient_contextMenu()<CR>
autocmd * nnoremap <buffer>
  \ <leader>gf :call LanguageClient_textDocument_documentSymbol()<cr>


Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/deoplete.nvim'
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = "virtual"
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#sources = {}
let g:deoplete#sources.php = ['LanguageClient', 'neosnippet']
let g:neosnippet#enable_completed_snippet = 1
imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>\"

set completeopt-=preview
imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
autocmd InsertLeave * if pumvisible() == 0 | pclose | endif


" UI
Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

Plug 'itchyny/lightline.vim' " Config below
Plug 'mgee/lightline-bufferline'
Plug 'shinchu/lightline-gruvbox.vim'
Plug 'tpope/vim-eunuch'
Plug 'haya14busa/vim-asterisk'
Plug 'tpope/vim-sensible'
Plug 'tommcdo/vim-exchange'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'terryma/vim-multiple-cursors'
Plug 'morhetz/gruvbox'

Plug 'FooSoft/vim-argwrap'
nnoremap <silent> <leader>a :ArgWrap<CR>

Plug 'myusuf3/numbers.vim'
" Fix for C-c not resetting the numbers
inoremap <C-c> <Esc>

Plug 'simnalamburt/vim-mundo'
nnoremap <F1> :MundoToggle<CR>
let g:mundo_width=35
let g:mundo_preview_height=15
let g:mundo_preview_bottom=1

Plug 'mhinz/vim-signify'


" Search and navigation
Plug 'machakann/vim-highlightedyank'
Plug 'simeji/winresizer'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-repeat'
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'IngoHeimbach/fzf.vim'
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

set smartcase
set incsearch
set ignorecase " by default ignore case
let g:fzf_files_options = '--color "border:#6699cc,info:#fabd2f"'
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_COMMAND="rg -S --files --follow --hidden  --glob '!.hg' --glob '!.git' --glob '!vendor'"
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
set splitbelow
set splitright

" Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

nmap <C-p> :Files<CR>

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader><Enter> :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>


" Syntax
Plug 'neomake/neomake'
autocmd! BufWritePost * Neomake
autocmd! BufReadPost * Neomake
let g:neomake_elixir_enabled_makers = ['mix', 'credo']
let g:neomake_php_phpcs_args_standard = "SHAKA"
let g:neomake_phpstan_level = 7
let g:neomake_php_phpmd_args = ['%:p', 'text', '/home/elishahastings/source/dotfiles/phpmd-ruleset.xml']

Plug 'sbdchd/neoformat'
let g:neoformat_php_phpcbf = {
      \ 'exe': 'phpcbf',
      \ 'args': [
      \ '--standard=SHAKA-AUTOFIX',
      \ '--extensions=php',
      \ '%',
      \ '||',
      \ 'true'
      \ ],
      \ 'stdin': 1,
      \ 'no_append': 1
      \ }
let g:neoformat_enabled_php = ['phpcbf']
nnoremap <leader>nf :Neoformat<cr>

" VCS and remote stuff
Plug 'floobits/floobits-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'whiteinge/diffconflicts'
Plug 'sjl/splice.vim'
let g:splice_prefix = "`"
let g:splice_initial_layout_grid = 1
let g:splice_initial_diff_grid = 1
let g:splice_initial_scrollbind_grid = 1
let g:splice_initial_scrollbind_compare = 1


" Language support
Plug 'sheerun/vim-polyglot'


" PHP
Plug 'vim-vdebug/vdebug'
if !exists('g:vdebug_options')
    let g:vdebug_options = {
      \   'window_commands': {
      \     'DebuggerWatch': 'vertical belowright new +res',
      \     'DebuggerStack': 'belowright new +res0',
      \     'DebuggerStatus': 'belowright new +res0'
      \   },
      \ }
endif
let g:vdebug_options.watch_window_style = 'compact'
let g:vdebug_options.break_on_open = 0
highlight DbgBreakptLine ctermbg=none ctermfg=none
highlight DbgBreakptSign ctermbg=none ctermfg=green
highlight DbgCurrentLine ctermbg=none ctermfg=none
highlight DbgCurrentSign ctermbg=none ctermfg=red


" Elixir
Plug 'slashmili/alchemist.vim'

" CSV
Plug 'chrisbra/csv.vim'


" Elm
Plug 'elmcast/elm-vim'


call plug#end()

""""""""""""
" Settings "
""""""""""""

" Buffers
set hidden " let modified buffers be hidden
function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
command DeleteHiddenBuffers call DeleteHiddenBuffers()

" General UI
set title " Show buffer name in title
set nowrap
set cursorline
set noshowmode
set shortmess+=c
set listchars=tab:>\
set backspace=indent,eol,start " smart backspace
set inccommand=nosplit
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Whitespace
set autoindent " preserve indentation
set cinkeys-=0# " don't force # indentation
set expandtab " no real tabs
set shiftround " be clever with tabs
set shiftwidth=4 " default 2
set smarttab " tab to 0,4,8 etc.
set softtabstop=4 " "tab" feels like <tab>
set tabstop=4 " replace <TAB> w/2 spaces

" Change background at 120 characters
execute "set colorcolumn=" . join(range(121,335), ',')
highlight ColorColumn ctermbg=235

" Syntax highlighting
syntax on
filetype plugin on
filetype plugin indent on

" Theme
set background=dark
colorscheme gruvbox
set termguicolors

" IO
set autoread " refresh if changed
set confirm " confirm changed files
set noautowrite " never autowrite
set nobackup " disable backups

" Persistent undo
set undodir=$HOME/.config/nvim/undo/ " where to store undofiles
set undofile " enable undofile
set undolevels=500 " max undos stored
set undoreload=10000 " buffer stored undos

" Commands
call neomake#configure#automake('nrwi', 500)

" Yank(copy) to system clipboard
noremap <leader>y "+y

" Lightline
let g:lightline = {
  \   'colorscheme': 'gruvbox',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'gitbranch', 'readonly', 'modified', 'buffers' ]
  \     ]
  \   },
  \   'component': {
  \     'lineinfo': ' %3l:%-2v',
  \   },
  \   'component_expand': {
  \     'buffers': 'lightline#bufferline#buffers'
  \   },
  \   'component_type': {
  \     'buffers': 'tabsel'
  \   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   }
  \ }

    """" Github repos, uncomment to disable a plugin
    ""Plug 'Shougo/denite.nvim'

    "" <Tab> everything!
    "Plug 'ervandew/supertab'

    "" Super easy commenting, toggle comments etc
    "Plug 'scrooloose/nerdcommenter'

    "" Autoclose (, " etc
    "Plug 'Townk/vim-autoclose'

    "" Handle surround chars like ''
    "Plug 'tpope/vim-surround'

    "" A fancy start screen, shows MRU etc.
    "Plug 'mhinz/vim-startify'

    "" Vim signs (:h signs) for modified lines based off VCS (e.g. Git)
    ""Plug 'airblade/vim-gitgutter'

    "Plug 'NLKNguyen/vim-lisp-syntax'

    "" Detect whitespace
    "Plug 'ntpeters/vim-better-whitespace'

    "" Code analysis
    "Plug 'ngmy/vim-rubocop'

    "" End completion
    "Plug 'tpope/vim-endwise'

    "" RACER!
    "Plug 'phildawes/racer'

    "" Unimpaired vim!
    "Plug 'tpope/vim-unimpaired'

    "Plug 'gregsexton/MatchTag'
    "Plug 'qpkorr/vim-bufkill'
    "Plug 'tpope/tpope-vim-abolish'
    "Plug 'junegunn/goyo.vim'
    "Plug 'junegunn/limelight.vim'
    "Plug 'phux/vim-hardtime'

    "Plug 'OmniSharp/omnisharp-vim'
    "Plug 'OrangeT/vim-csharp'

    "Plug 'pangloss/vim-javascript'
    "Plug 'ternjs/tern_for_vim'

    "Plug 'vim-scripts/dbext.vim'
    "Plug 'shmup/vim-sql-syntax'

    "Plug 'sunaku/vim-dasht'

    "Plug 'mechatroner/rainbow_csv'
