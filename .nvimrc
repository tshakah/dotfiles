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
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <F7> :call LanguageClient_contextMenu()<CR>

Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/deoplete.nvim'
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#sources#padawan#add_parentheses = 0
let g:deoplete#sources = {}
let g:deoplete#sources.php = ['padawan', 'neosnippet', 'tags', 'buffer']
let g:AutoPairsMapCR=0
let g:neosnippet#enable_completed_snippet = 1
imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
autocmd InsertLeave * if pumvisible() == 0 | pclose | endif


" UI
Plug 'itchyny/lightline.vim' " Config below
Plug 'mgee/lightline-bufferline'
Plug 'tpope/vim-eunuch'
Plug 'haya14busa/vim-asterisk'
Plug 'tpope/vim-sensible'
Plug 'tommcdo/vim-exchange'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'terryma/vim-multiple-cursors'
Plug 'tshakah/gruvbox'

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
Plug 'easymotion/vim-easymotion'

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap <Leader>s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" Gif config
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
let g:EasyMotion_smartcase = 1

Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'

" You can use other keymappings like <C-l> instead of <CR> if you want to
" use these mappings as default search and somtimes want to move cursor with
" EasyMotion.
function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction


noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))
noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

Plug 'wellle/targets.vim'
Plug 'tpope/vim-repeat'
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'IngoHeimbach/fzf.vim'

set smartcase
set incsearch
set ignorecase " by default ignore case
let g:fzf_files_options = '--color "border:#6699cc,info:#fabd2f" --preview "highlight -O ansi --force {} 2> /dev/null"'
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


" VCS and remote stuff
Plug 'floobits/floobits-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'
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
    let g:vdebug_options = {}
endif
let g:vdebug_options.break_on_open = 0
let g:vdebug_options.watch_window_height = 10
let g:vdebug_options.status_window_height = 4

Plug 'padawan-php/deoplete-padawan', { 'do': 'composer install' }
command! PadawanStart call deoplete#sources#padawan#StartServer()
command! PadawanStop call deoplete#sources#padawan#StopServer()
command! PadawanRestart call deoplete#sources#padawan#RestartServer()
command! PadawanInstall call deoplete#sources#padawan#InstallServer()
command! PadawanUpdate call deoplete#sources#padawan#UpdatePadawan()
command! -bang PadawanGenerate call deoplete#sources#padawan#Generate(<bang>0)


" Elixir
Plug 'slashmili/alchemist.vim'


" Markdown
Plug 'JamshedVesuna/vim-markdown-preview'


call plug#end()

""""""""""""
" Settings "
""""""""""""

" Buffers
set hidden " let modified buffers be hidden

" General UI
set title " Show buffer name in title
set nowrap
set cursorline
set noshowmode
set shortmess+=c
set listchars=tab:>\
set backspace=indent,eol,start " smart backspace

" Whitespace
set autoindent " preserve indentation
set cinkeys-=0# " don't force # indentation
set expandtab " no real tabs
set shiftround " be clever with tabs
set shiftwidth=4 " default 2
set smarttab " tab to 0,4,8 etc.
set softtabstop=4 " "tab" feels like <tab>
set tabstop=4 " replace <TAB> w/2 spaces

" Theme
set background=dark
colorscheme gruvbox

" Change background at 120 characters
execute "set colorcolumn=" . join(range(121,335), ',')
highlight ColorColumn ctermbg=235

" Syntax highlighting
syntax on
filetype plugin on
filetype plugin indent on

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

    "" Elixir
    "Plug 'elixir-lang/vim-elixir'
    "Plug 'thinca/vim-ref'
    "Plug 'awetzel/elixir.nvim', { 'do': 'yes \| ./install.sh' }

    "Plug 'elmcast/elm-vim'

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
