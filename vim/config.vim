"--------------------------------------------------"
" Author:       Elisha Hastings                    "
" Homepage:     http://muckypupcreations.com       "
" Source:       http://github.com/tshakah/dotfiles "
"--------------------------------------------------"

" vim doesn't like fish :(
set shell=/run/current-system/sw/bin/bash

let mapleader="\<SPACE>"

" Automatically make needed files and folders on first run
call system("mkdir -p $HOME/.config/nvim/{swap,undo}")

"---------"
" Plugins "
"---------"
call plug#begin("~/.config/nvim/plugged")


" Environment
Plug 'tpope/vim-dotenv'

" Autocompletion
Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = "floating"

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'hrsh7th/nvim-compe'

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Status line
set statusline=%<%f\ %h%m%r
set statusline+=%=%-10.60{LspStatus()}\ %-.(%l,%c%V%)\ %P

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

Plug 'honza/vim-snippets'

" UI
" A fancy start screen
Plug 'mhinz/vim-startify'
let g:startify_change_to_vcs_root = 1
let g:startify_enable_special = 0
let g:startify_fortune_use_unicode = 1

let g:ascii = [
        \ '           A--A',
        \ '       .-./   #\.-.',
        \ '      ''--;d    b;--''',
        \ '         \# \/  /',
        \ '          \''--''/',
        \ '           |==|',
        \ '           | #|',
        \ '           |# |',
        \ '          /   #\',
        \ '         ;   #  ;',
        \ '         | #    |',
        \ '        /|  ,, #|\',
        \ '       /#|  ||  | \',
        \ '   .-.''  |# ||  |# ''.-.',
        \ '  (.=.),''|  ||# |'',(.=.)',
        \ '   ''-''  /  #)(   \  ''-''',
        \ '        `""`  `""`',
        \]

let g:startify_custom_header =
        \ 'map(startify#fortune#boxed() + g:ascii, "\"   \".v:val")'

Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

Plug 'itchyny/lightline.vim' " Config below
Plug 'mgee/lightline-bufferline'
Plug 'tpope/vim-eunuch'
Plug 'haya14busa/vim-asterisk'
Plug 'tpope/vim-sensible'
Plug 'tommcdo/vim-exchange'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'sainnhe/everforest'

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
Plug 'Yilin-Yang/vim-markbar'
nmap <Leader>m <Plug>ToggleMarkbar

Plug 'pechorin/any-jump.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'simeji/winresizer'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-repeat'
Plug 'chrisbra/NrrwRgn'

" Handle surround chars like ''
Plug 'tpope/vim-surround'

Plug 'brooth/far.vim'
let g:far#default_file_mask = '**/*.*'
let g:far#source = 'rgnvim'
nnoremap <buffer><silent> <C-J> :call g:far#scroll_preview_window(-g:far#preview_window_scroll_step)<cr>
nnoremap <buffer><silent> <C-K> :call g:far#scroll_preview_window(g:far#preview_window_scroll_step)<cr>

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#s_next = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
noremap 0 ^ " Go to the first non-blank character of a line
noremap ^ 0 " Just in case you need to go to the very beginning of a line

set smartcase
set ignorecase " by default ignore case
let g:fzf_files_options = '--color "border:#6699cc,info:#fabd2f"'
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_COMMAND="rg -S --files --follow --hidden --glob '!.hg' --glob '!.git' --glob '!vendor' --glob '!data' --glob '!_build' --glob '!.elixir_ls'"
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
nmap <C-space> :Buffers<CR>

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction


" Syntax
"Plug 'sbdchd/neoformat'
"let g:neoformat_php_phpcbf = {
"      \ 'exe': 'phpcbf',
"      \ 'args': [
"      \ '--standard=CAPCS',
"      \ '--extensions=php',
"      \ '%',
"      \ '||',
"      \ 'true'
"      \ ],
"      \ 'stdin': 1,
"      \ 'no_append': 1
"      \ }
"let g:neoformat_enabled_php = ['phpcbf']
"nnoremap <leader>nf :Neoformat<cr>

" VCS and remote stuff
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'whiteinge/diffconflicts'
Plug 'albfan/splice.vim'
let g:splice_prefix = "`"
let g:splice_initial_layout_grid = 1
let g:splice_initial_diff_grid = 1
let g:splice_initial_scrollbind_grid = 1
let g:splice_initial_scrollbind_compare = 1

Plug 'airblade/vim-gitgutter'
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'
let g:gitgutter_override_sign_column_highlight = 1


" Language support
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ["autoindent", "sensible", "csv"]

" We recommend updating the parsers on update
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


" Elixir
Plug 'slashmili/alchemist.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'mhinz/vim-mix-format'
let g:mix_format_on_save = 1


" Elm
Plug 'elmcast/elm-vim'
let g:elm_format_autosave = 1


" PHP
Plug 'StanAngeloff/php.vim'
function! PhpSyntaxOverride()
  hi phpUseNamespaceSeparator guifg=#808080 guibg=NONE gui=NONE
  hi phpClassNamespaceSeparator guifg=#808080 guibg=NONE gui=NONE
endfunction

Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END

Plug 'rayburgemeestre/phpfolding.vim'

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


" REPL(ish)
augroup replcmds
  autocmd! replcmds
  autocmd Filetype rust nmap <buffer> <silent> <F7> <ESC>println!("{:?}",);<ESC>:w<CR>hh
  autocmd Filetype php nmap <buffer> <silent> <F7> <ESC>oeval(\Psy\sh());<ESC>:w<CR>
  autocmd Filetype elixir nmap <buffer> <silent> <F7> <ESC>orequire IEx; IEx.pry<ESC> :w<CR>
augroup end


" Databases
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
nmap <C-]> :DBUIToggle<CR>


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
set updatetime=300
set completeopt=menuone,noselect
set title " Show buffer name in title
set sidescroll=2
set listchars+=precedes:<,extends:>
set cursorline
set noshowmode
set shortmess+=c
set inccommand=nosplit
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
set foldmethod=syntax
set foldlevel=1

set incsearch
set nohlsearch
" allows incsearch highlighting for range commands
cnoremap $t <CR>:t''<CR>
cnoremap $T <CR>:T''<CR>
cnoremap $m <CR>:m''<CR>
cnoremap $M <CR>:M''<CR>
cnoremap $d <CR>:d<CR>``

" Whitespace
set cinkeys-=0# " don't force # indentation
set nowrap
set expandtab " no real tabs
set shiftround " be clever with tabs
set showbreak=\ →\
set breakindent
set shiftwidth=4 " default 2
set softtabstop=4 " "tab" feels like <tab>
set tabstop=4 " replace <TAB> w/2 spaces

" Maximise a split
nnoremap <C-W><C-O> :call MaximizeToggle()<CR>

function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction

" Change background at 120 characters
execute "set colorcolumn=" . join(range(121,335), ',')
highlight ColorColumn ctermbg=235

" Theme
set background=dark
let g:everforest_background = 'hard'
let g:everforest_diagnostic_text_highlight = 1
let g:everforest_diagnostic_line_highlight = 1
let g:everforest_enable_italic = 1
set termguicolors
colorscheme everforest

" Syntax highlighting
syntax on
filetype on
filetype plugin indent on

" IO
set confirm " confirm changed files
set noautowrite " never autowrite
set nobackup " disable backups

" Persistent undo
set undodir=$HOME/.config/nvim/undo/ " where to store undofiles
set undofile " enable undofile
set undolevels=500 " max undos stored
set undoreload=10000 " buffer stored undos

" Yank(copy) to system clipboard
noremap <leader>y "+y

" Lightline
let g:lightline = {
  \   'colorscheme': 'everforest',
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
  \     'gitbranch': 'fugitive#head'
  \   }
  \ }

" Loads lua config
lua require('init')

    "" <Tab> everything!
    "Plug 'ervandew/supertab'

    "" Autoclose (, " etc
    "Plug 'Townk/vim-autoclose'

    "" End completion
    "Plug 'tpope/vim-endwise'

    "" Unimpaired vim!
    "Plug 'tpope/vim-unimpaired'

    "Plug 'gregsexton/MatchTag'
    "Plug 'qpkorr/vim-bufkill'
    "Plug 'tpope/tpope-vim-abolish'
    "Plug 'junegunn/goyo.vim'
    "Plug 'junegunn/limelight.vim'
    "Plug 'phux/vim-hardtime'

    "Plug 'pangloss/vim-javascript'
    "Plug 'ternjs/tern_for_vim'

    "Plug 'vim-scripts/dbext.vim'
    "Plug 'shmup/vim-sql-syntax'

    "Plug 'sunaku/vim-dasht'
