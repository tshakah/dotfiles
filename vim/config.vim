"--------------------------------------------------"
" Author:       Elisha Hastings                    "
" Homepage:     http://muckypupcreations.com       "
" Source:       http://github.com/tshakah/dotfiles "
"--------------------------------------------------"

" vim doesn't like fish :(
set shell=/bin/sh

let mapleader="\<SPACE>"

" Automatically make needed files and folders on first run
call system("mkdir -p $HOME/.config/nvim/{swap,undo}")

"---------"
" Plugins "
"---------"
call plug#begin("~/.config/nvim/plugged")


" Autocompletion
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/deoplete.nvim'
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = "floating"
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
let g:neosnippet#enable_completed_snippet = 1
imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
imap <expr><CR> pumvisible() ? deoplete#close_popup() : "\<CR>\"

set completeopt-=preview
imap <expr><TAB> pumvisible() ? "\<C-n>" : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>")
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
imap <expr><CR> pumvisible() ? deoplete#close_popup() : "\<CR>"
autocmd InsertLeave * if pumvisible() == 0 | pclose | endif


" UI
" A fancy start screen
Plug 'mhinz/vim-startify'
let g:startify_change_to_vcs_root = 1
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
Plug 'morhetz/gruvbox'
Plug 'shinchu/lightline-gruvbox.vim'

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
Plug 'vim-ctrlspace/vim-ctrlspace'
let g:CtrlSpaceDefaultMappingKey = "<C-space> "
set showtabline=0

Plug 'machakann/vim-highlightedyank'
Plug 'simeji/winresizer'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-repeat'
Plug 'chrisbra/NrrwRgn'

Plug 'brooth/far.vim'
let g:far#default_file_mask = '**/*.*'
let g:far#source = 'rgnvim'
nnoremap <buffer><silent> <C-J> :call g:far#scroll_preview_window(-g:far#preview_window_scroll_step)<cr>
nnoremap <buffer><silent> <C-K> :call g:far#scroll_preview_window(g:far#preview_window_scroll_step)<cr>

Plug 'lotabout/skim.vim'
set rtp+=~/.skim

Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
Plug 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" Move across wrapped lines like regular lines
noremap 0 ^ " Go to the first non-blank character of a line
noremap ^ 0 " Just in case you need to go to the very beginning of a line

set smartcase
set ignorecase " by default ignore case
let g:fzf_files_options = '--color "border:#6699cc,info:#fabd2f"'
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let $FZF_DEFAULT_COMMAND="rg -S --files --follow --hidden --glob '!.hg' --glob '!.git' --glob '!vendor' --glob '!data'"
let $SKIM_DEFAULT_COMMAND="rg -S --files --follow --hidden --glob '!.hg' --glob '!.git' --glob '!vendor' --glob '!data'"
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
Plug 'junkblocker/patchreview-vim'
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'whiteinge/diffconflicts'
Plug 'albfan/splice.vim'
let g:splice_prefix = "`"
let g:splice_initial_layout_grid = 1
let g:splice_initial_diff_grid = 1
let g:splice_initial_scrollbind_grid = 1
let g:splice_initial_scrollbind_compare = 1


" Language support
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['csv']

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>


" Elixir
Plug 'slashmili/alchemist.vim'
Plug 'elixir-editors/vim-elixir'


" Elm
Plug 'elmcast/elm-vim'


" PHP
Plug 'rayburgemeestre/phpfolding.vim'
Plug 'roxma/LanguageServer-php-neovim', {'do': 'composer install && composer run-script parse-stubs'}

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


" REPL
augroup replcmds
  autocmd! replcmds
  autocmd Filetype rust nmap <buffer> <silent> <F7> <ESC>println!("{:?}",);<ESC>:w<CR>hh
  autocmd Filetype php nmap <buffer> <silent> <F7> <ESC>oeval(\Psy\sh());<ESC>:w<CR>
  autocmd Filetype elixir nmap <buffer> <silent> <F7> <ESC>orequire IEx; IEx.pry<ESC> :w<CR>
augroup end


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
cnoremap $t <CR>:t''<CR>
cnoremap $T <CR>:T''<CR>
cnoremap $m <CR>:m''<CR>
cnoremap $M <CR>:M''<CR>
cnoremap $d <CR>:d<CR>``

" Handle surround chars like ''
Plug 'tpope/vim-surround'

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

" Syntax highlighting
filetype plugin on

" Theme
set background=dark
colorscheme gruvbox
set termguicolors

" IO
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

    "" <Tab> everything!
    "Plug 'ervandew/supertab'

    "" Autoclose (, " etc
    "Plug 'Townk/vim-autoclose'

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
