"-----------------------------------------------"
" Author:       Tim Sæterøy                     "
" Homepage:     http://thevoid.no               "
" Source:       http://github.com/timss/vimconf "
"-----------------------------------------------"

" vimconf is not vi-compatible
set nocompatible

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
Plug 'terryma/vim-multiple-cursors'
Plug 'tshakah/gruvbox'
Plug 'myusuf3/numbers.vim'
" Fix for C-c not resetting the numbers
inoremap <C-c> <Esc>

Plug 'simnalamburt/vim-mundo'
nnoremap <F1> :MundoToggle<CR>
let g:mundo_width=35
let g:mundo_preview_height=15
let g:mundo_preview_bottom=1


" Search and navigation
Plug 'dyng/ctrlsf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'IngoHeimbach/fzf.vim'

let mapleader="\<SPACE>"
set smartcase
set incsearch
set ignorecase " by default ignore case
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

    "Plug 'floobits/floobits-neovim', { 'do': ':UpdateRemotePlugins' }

    """" Github repos, uncomment to disable a plugin
    "Plug 'tpope/vim-sensible'
    ""Plug 'Shougo/denite.nvim'

    "Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
    "Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}

    ""Plug 'roxma/nvim-completion-manager'
    "Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    "Plug 'padawan-php/deoplete-padawan', { 'do': 'composer install' }

    "" Showing function signature and inline doc.
    "Plug 'Shougo/echodoc.vim'

    "" <Tab> everything!
    "Plug 'ervandew/supertab'

    "Plug 'tpope/vim-repeat'
    "Plug 'wellle/targets.vim'

    "" Fuzzy finder (files, mru, etc)
    ""Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
    ""Plug 'lotabout/skim.vim'
    "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    "Plug 'IngoHeimbach/fzf.vim'
    "Plug 'airblade/vim-rooter'

    "" Better line numbers
    "Plug 'myusuf3/numbers.vim'

    "" A pretty statusline, bufferline integration
    "Plug 'itchyny/lightline.vim'
    "Plug 'mgee/lightline-bufferline'

    "" Easy... motions... yeah.
    "Plug 'easymotion/vim-easymotion'
    "Plug 'haya14busa/incsearch.vim'
    "Plug 'haya14busa/incsearch-fuzzy.vim'
    "Plug 'haya14busa/incsearch-easymotion.vim'

    "" Glorious colorschemes
    "Plug 'tshakah/gruvbox'

    "" Super easy commenting, toggle comments etc
    "Plug 'scrooloose/nerdcommenter'

    "" Autoclose (, " etc
    "Plug 'Townk/vim-autoclose'

    "" Git wrapper inside Vim
    "Plug 'tpope/vim-fugitive'
    "Plug 'ludovicchabant/vim-lawrencium'

    "" PHP
    "Plug 'StanAngeloff/php.vim'
    "Plug 'janko-m/vim-test'

    "" Handle surround chars like ''
    "Plug 'tpope/vim-surround'

    "" Snippets like textmate
    "Plug 'MarcWeber/vim-addon-mw-utils'
    "Plug 'tomtom/tlib_vim'
    "Plug 'sirver/ultisnips'

    "" A fancy start screen, shows MRU etc.
    "Plug 'mhinz/vim-startify'

    "" Vim signs (:h signs) for modified lines based off VCS (e.g. Git)
    ""Plug 'airblade/vim-gitgutter'
    "Plug 'mhinz/vim-signify'

    "" Awesome syntax checker.
    "" REQUIREMENTS: See :h syntastic-intro
    "Plug 'scrooloose/syntastic'
    "Plug 'wting/rust.vim'

    "Plug 'NLKNguyen/vim-lisp-syntax'

    "" Detect whitespace
    "Plug 'ntpeters/vim-better-whitespace'

    "" Code analysis
    "Plug 'ngmy/vim-rubocop'

    "" End completion
    "Plug 'tpope/vim-endwise'

    "" Shell commands
    "Plug 'tpope/vim-eunuch'

    "" RACER!
    "Plug 'phildawes/racer'

    "" Unimpaired vim!
    "Plug 'tpope/vim-unimpaired'

    "Plug 'dyng/ctrlsf.vim'
    "Plug 'terryma/vim-multiple-cursors'

    "" Undo tree
    "Plug 'simnalamburt/vim-mundo'

    "" Elixir
    "Plug 'elixir-lang/vim-elixir'
    "Plug 'thinca/vim-ref'
    "Plug 'awetzel/elixir.nvim', { 'do': 'yes \| ./install.sh' }

    "Plug 'elmcast/elm-vim'

    "" Twig
    "Plug 'qbbr/vim-twig'

    "Plug 'gregsexton/MatchTag'
    "Plug 'qpkorr/vim-bufkill'
    "Plug 'tpope/tpope-vim-abolish'
    "Plug 'haya14busa/vim-asterisk'
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
