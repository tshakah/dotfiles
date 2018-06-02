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
imap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>\<Plug>AutoPairsReturn"
autocmd InsertLeave * if pumvisible() == 0 | pclose | endif


" UI
Plug 'tshakah/gruvbox'


Plug 'simnalamburt/vim-mundo'
nnoremap <F1> :MundoToggle<CR>
let g:mundo_width=35
let g:mundo_preview_height=15
let g:mundo_preview_bottom=1


" Search
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'lotabout/skim.vim'


" PHP
Plug 'StanAngeloff/php.vim', {'for': 'php'}
Plug 'vim-vdebug/vdebug'


Plug 'padawan-php/deoplete-padawan', { 'do': 'composer install' }
command! PadawanStart call deoplete#sources#padawan#StartServer()
command! PadawanStop call deoplete#sources#padawan#StopServer()
command! PadawanRestart call deoplete#sources#padawan#RestartServer()
command! PadawanInstall call deoplete#sources#padawan#InstallServer()
command! PadawanUpdate call deoplete#sources#padawan#UpdatePadawan()
command! -bang PadawanGenerate call deoplete#sources#padawan#Generate(<bang>0)


call plug#end()

"----------"
" Settings "
"----------"
" Buffers
set hidden

" General UI
set nowrap
set incsearch
set cursorline
set noshowmode
set shortmess+=c
set listchars=tab:>\

" Theme
set background=dark
colorscheme gruvbox 

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

" Settings

" Commands

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
    "Plug 'joonty/vdebug'
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
