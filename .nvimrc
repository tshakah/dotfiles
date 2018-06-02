"-----------------------------------------------"
" Author:       Tim Sæterøy                     "
" Homepage:     http://thevoid.no               "
" Source:       http://github.com/timss/vimconf "
"-----------------------------------------------"

" vimconf is not vi-compatible
set nocompatible

""" Automatically make needed files and folders on first run
""" If you don't run *nix you're on your own (as in remove this) {{{
    call system("mkdir -p $HOME/.config/nvim/{swap,undo}")
""" }}}
    call plug#begin("~/.config/nvim/plugged")

    Plug 'floobits/floobits-neovim', { 'do': ':UpdateRemotePlugins' }

    """ Github repos, uncomment to disable a plugin
    Plug 'tpope/vim-sensible'
    "Plug 'Shougo/denite.nvim'

    Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
    Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}

    "Plug 'roxma/nvim-completion-manager'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    Plug 'padawan-php/deoplete-padawan', { 'do': 'composer install' }

    " Showing function signature and inline doc.
    Plug 'Shougo/echodoc.vim'

    " <Tab> everything!
    Plug 'ervandew/supertab'

    Plug 'tpope/vim-repeat'
    Plug 'wellle/targets.vim'

    " Fuzzy finder (files, mru, etc)
    "Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
    "Plug 'lotabout/skim.vim'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'IngoHeimbach/fzf.vim'
    Plug 'airblade/vim-rooter'

    " Better line numbers
    Plug 'myusuf3/numbers.vim'

    " A pretty statusline, bufferline integration
    Plug 'itchyny/lightline.vim'
    Plug 'mgee/lightline-bufferline'

    " Easy... motions... yeah.
    Plug 'easymotion/vim-easymotion'
    Plug 'haya14busa/incsearch.vim'
    Plug 'haya14busa/incsearch-fuzzy.vim'
    Plug 'haya14busa/incsearch-easymotion.vim'

    " Glorious colorschemes
    Plug 'tshakah/gruvbox'

    " Super easy commenting, toggle comments etc
    Plug 'scrooloose/nerdcommenter'

    " Autoclose (, " etc
    Plug 'Townk/vim-autoclose'

    " Git wrapper inside Vim
    Plug 'tpope/vim-fugitive'
    Plug 'ludovicchabant/vim-lawrencium'

    " PHP
    Plug 'vim-vdebug/vdebug'
    Plug 'StanAngeloff/php.vim'
    Plug 'janko-m/vim-test'

    " Handle surround chars like ''
    Plug 'tpope/vim-surround'

    " Snippets like textmate
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'tomtom/tlib_vim'
    Plug 'sirver/ultisnips'

    " A fancy start screen, shows MRU etc.
    Plug 'mhinz/vim-startify'

    " Vim signs (:h signs) for modified lines based off VCS (e.g. Git)
    "Plug 'airblade/vim-gitgutter'
    Plug 'mhinz/vim-signify'

    " Awesome syntax checker.
    " REQUIREMENTS: See :h syntastic-intro
    Plug 'scrooloose/syntastic'
    Plug 'wting/rust.vim'

    Plug 'NLKNguyen/vim-lisp-syntax'

    " Detect whitespace
    Plug 'ntpeters/vim-better-whitespace'

    " Code analysis
    Plug 'ngmy/vim-rubocop'

    " End completion
    Plug 'tpope/vim-endwise'

    " Shell commands
    Plug 'tpope/vim-eunuch'

    " RACER!
    Plug 'phildawes/racer'

    " Unimpaired vim!
    Plug 'tpope/vim-unimpaired'

    Plug 'dyng/ctrlsf.vim'
    Plug 'terryma/vim-multiple-cursors'

    " Undo tree
    Plug 'simnalamburt/vim-mundo'

    " Elixir
    Plug 'elixir-lang/vim-elixir'
    Plug 'thinca/vim-ref'
    Plug 'awetzel/elixir.nvim', { 'do': 'yes \| ./install.sh' }

    Plug 'elmcast/elm-vim'

    " Twig
    Plug 'qbbr/vim-twig'

    Plug 'gregsexton/MatchTag'
    Plug 'qpkorr/vim-bufkill'
    Plug 'tpope/tpope-vim-abolish'
    Plug 'haya14busa/vim-asterisk'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'phux/vim-hardtime'

    Plug 'OmniSharp/omnisharp-vim'
    Plug 'OrangeT/vim-csharp'

    Plug 'pangloss/vim-javascript'
    Plug 'ternjs/tern_for_vim'

    Plug 'vim-scripts/dbext.vim'
    Plug 'shmup/vim-sql-syntax'

    Plug 'sunaku/vim-dasht'

    Plug 'mechatroner/rainbow_csv'

    " Finish plugin stuff
    call plug#end()

""" }}}
""" User interface {{{
    """ Syntax highlighting {{{
        filetype plugin on
        filetype plugin indent on                   " detect file plugin+indent
        syntax on                                   " syntax highlighting
        set background=dark                         " we're using a dark bg
        colorscheme gruvbox                         " colorscheme from plugin
        """ .txt w/highlight, plaintex is useless, markdown for .md {{{
            augroup FileTypeRules
                autocmd!
                autocmd BufNewFile,BufRead *.txt set ft=sh tw=79
                autocmd BufNewFile,BufRead *.tex set ft=tex tw=79
                autocmd BufNewFile,BufRead *.md set ft=markdown tw=79
                autocmd BufNewFile,BufRead *.endfile set filetype=endfile
            augroup END
        """ }}}
        """ 256 colors for maximum jellybeans bling. See commit log for info {{{
            if (&term =~ "xterm") || (&term =~ "screen")
                set t_Co=256
            endif
            if $COLORTERM == 'gnome-terminal'
              set t_Co=256
            endif
        """ }}}
        """ Tab colors, overwritten by lightline(?) {{{
            "hi TabLineFill ctermfg=NONE ctermbg=233
            "hi TabLine ctermfg=241 ctermbg=233
            "hi TabLineSel ctermfg=250 ctermbg=233
        """ }}}
        """ Custom highlighting, where NONE uses terminal background {{{
            function! CustomHighlighting()
                highlight Normal ctermbg=NONE
                highlight NonText ctermbg=NONE
                highlight LineNr ctermbg=NONE
                highlight SignColumn ctermbg=NONE
                highlight SignColumn guibg=#151515
                highlight CursorLine ctermbg=237
            endfunction

            call CustomHighlighting()
        """ }}}
    """ }}}
    """ Interface general {{{
        set inccommand=split
        set cursorline                              " highlight cursor line
        set more                                    " ---more--- like less
        set scrolloff=3                             " lines above/below cursor
        set showcmd                                 " show cmds being typed
        set title                                   " window title
        set vb t_vb=                                " disable beep and flashing
        set wildignore=*.a,*.o,*.so,*.pyc,*.jpg,
                    \*.jpeg,*.png,*.gif,*.pdf,*.git,
                    \*.swp,*.swo                    " tab completion ignores
        set wildmenu                                " better auto complete
        set wildmode=longest,list                   " bash-like auto complete
        """ Depending on your setup you may want to enforce UTF-8.
        """ Should generally be set in your environment LOCALE/$LANG {{{
            " set encoding=utf-8                    " default $LANG/latin1
            " set fileencoding=utf-8                " default none
        """ }}}
        """ Gvim {{{
            set guifont=DejaVu\ Sans\ Mono\ 9
            set guioptions-=m                       " remove menubar
            set guioptions-=T                       " remove toolbar
            set guioptions-=r                       " remove right scrollbar
        """ }}}
    """ }}}
""" }}}
""" General settings {{{
    set hidden                                      " buffer change, more undo
    set history=1000                                " default 20
    set iskeyword+=_,$,@,%,#                        " not word dividers
    set laststatus=2                                " always show statusline
    set linebreak                                   " don't cut words on wrap
    set listchars=tab:>\                            " > to highlight <tab>
    set list                                        " displaying listchars
    set mouse=                                      " disable mouse
    set noshowmode                                  " hide mode cmd line
    set noexrc                                      " don't use other .*rc(s)
    set nostartofline                               " keep cursor column pos
    set nowrap                                      " don't wrap lines
    set numberwidth=5                               " 99999 lines
    set shortmess+=I                                " disable startup message
    set splitbelow                                  " splits go below w/focus
    set splitright                                  " vsplits go right w/focus
    """ Search and replace {{{
        set gdefault                                " default s//g (global)
        set incsearch                               " "live"-search
    """ }}}
    """ Matching {{{
        set matchtime=2                             " time to blink match {}
        set matchpairs+=<:>                         " for ci< or ci>
        set showmatch                               " tmpjump to match-bracket
    """ }}}
    """ Return to last edit position when opening files {{{
        augroup LastPosition
            autocmd! BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \     exe "normal! g`\"" |
                \ endif
        augroup END
    """ }}}
""" }}}
""" Files {{{
    set autoread                                    " refresh if changed
    set confirm                                     " confirm changed files
    set noautowrite                                 " never autowrite
    set nobackup                                    " disable backups
    """ Persistent undo. Requires Vim 7.3 {{{
        if has('persistent_undo') && exists("&undodir")
            set undodir=$HOME/.config/nvim/undo/            " where to store undofiles
            set undofile                            " enable undofile
            set undolevels=500                      " max undos stored
            set undoreload=10000                    " buffer stored undos
        endif
    """ }}}
    """ Swap files, unless vim is invoked using sudo. Inspired by tejr's vimrc
    """ https://github.com/tejr/dotfiles/blob/master/vim/vimrc {{{
        if !strlen($SUDO_USER)
            set directory^=$HOME/.config/nvim/swap//        " default cwd, // full path
            set swapfile                            " enable swap files
            set updatecount=50                      " update swp after 50chars
            """ Don't swap tmp, mount or network dirs {{{
                augroup SwapIgnore
                    autocmd! BufNewFile,BufReadPre /tmp/*,/mnt/*,/media/*
                                \ setlocal noswapfile
                augroup END
            """ }}}
        else
            set noswapfile                          " dont swap sudo'ed files
        endif
    """ }}}
""" }}}
""" Text formatting {{{
    set autoindent                                  " preserve indentation
    set backspace=indent,eol,start                  " smart backspace
    set cinkeys-=0#                                 " don't force # indentation
    set expandtab                                   " no real tabs
    set ignorecase                                  " by default ignore case
    set nrformats+=alpha                            " incr/decr letters C-a/-x
    set shiftround                                  " be clever with tabs
    set shiftwidth=4                                " default 2
    set smartcase                                   " sensitive with uppercase
    set smarttab                                    " tab to 0,4,8 etc.
    set softtabstop=4                               " "tab" feels like <tab>
    set tabstop=4                                   " replace <TAB> w/2 spaces
    set foldmethod=syntax
    set foldnestmax=10
    set nofoldenable
    set foldlevel=2
    """ Only auto-comment newline for block comments {{{
        augroup AutoBlockComment
            autocmd! FileType c,cpp setlocal comments -=:// comments +=f://
        augroup END
    """ }}}
    """ Take comment leaders into account when joining lines, :h fo-table
    """ http://ftp.vim.org/pub/vim/patches/7.3/7.3.541 {{{
        if has("patch-7.3.541")
            set formatoptions+=j
        endif
    """ }}}

    " Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   "rg -S --column --line-number --no-heading --color=always --glob '!.hg' --glob '!.git' ".shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

" MySQL
let g:dbext_default_profile_hope = 'type=MYSQL:user=root:passwd=password:dbname=hope01'

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_history_dir = '~/.local/share/fzf-history'

let $FZF_DEFAULT_COMMAND="rg -S --files --follow --hidden  --glob '!.hg' --glob '!.git' --glob '!vendor'"

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>o :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>

execute "set colorcolumn=" . join(range(121,335), ',')
highlight ColorColumn ctermbg=235

set grepprg=rg\ --vimgrep

let g:fzf_layout = { 'down': '~40%' }

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

""" }}}
""" Keybindings {{{
    """ General {{{
        " Remap <leader>
        let mapleader=" "
        let g:ctrlsf_ackprg = 'rg'

        nnoremap <silent> + :exe "resize " . (winheight(0) * 3/2)<CR>
        nnoremap <silent> - :exe "resize " . (winheight(0) * 2/3)<CR>

        nnoremap <Leader>d :Dasht<Space>
        nnoremap <silent> <Leader>D :call Dasht([expand('<cword>'), expand('<cWORD>')])<Return>

        map <Leader>l <Plug>(easymotion-lineforward)
        map <Leader>j <Plug>(easymotion-j)
        map <Leader>k <Plug>(easymotion-k)
        map <Leader>h <Plug>(easymotion-linebackward)

        let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

        noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())
        map ?  <Plug>(incsearch-backward)
        map g/ <Plug>(incsearch-stay)

        function! s:config_easyfuzzymotion(...) abort
        return extend(copy({
        \   'converters': [incsearch#config#fuzzyword#converter()],
        \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
        \   'keymap': {"\<CR>": '<Over>(easymotion)'},
        \   'is_expr': 0,
        \   'is_stay': 1
        \ }), get(a:, 1, {}))
        endfunction

        noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

        let g:dasht_filetype_docsets = {}
        let g:deoplete#sources#padawan#add_parentheses = 0

        let g:dasht_filetype_docsets['elixir'] = ['erlang']
        let g:dasht_filetype_docsets['php'] = ['phpunit', 'doctrine_orm']
        let g:dasht_filetype_docsets['twig'] = ['html', 'sass', 'css', 'js', 'bootstrap']
        let g:dasht_filetype_docsets['js'] = ['vuejs', 'jquery', 'jquery_ui', 'momentjs']
        let g:dasht_filetype_docsets['handlebars'] = ['html']

        " Quickly edit/source .vimrc
        noremap <leader>ve :edit $HOME/source/dotfiles/.nvimrc<CR>
        noremap <leader>vs :source $HOME/.config/nvim/init.vim<CR>

        " Terminal mode & window navigation
        :tnoremap <C-c> <C-\><C-n>
        :tnoremap <A-h> <C-\><C-n><C-w>h
        :tnoremap <A-j> <C-\><C-n><C-w>j
        :tnoremap <A-k> <C-\><C-n><C-w>k
        :tnoremap <A-l> <C-\><C-n><C-w>l
        :nnoremap <A-h> <C-w>h
        :nnoremap <A-j> <C-w>j
        :nnoremap <A-k> <C-w>k
        :nnoremap <A-l> <C-w>l

        let g:LanguageClient_autoStart = 1

        nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
        nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
        nnoremap <silent> ge :call LanguageClient_textDocument_rename()<CR>

        let g:LanguageClient_serverCommands = {
        \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
        \ }

        nnoremap <silent> <leader>/ :CtrlSF -smartcase

        " Yank(copy) to system clipboard
        noremap <leader>y "+y

        " Bubbling (bracket matching)
        nmap <C-up> [e
        nmap <C-down> ]e
        vmap <C-up> [egv
        vmap <C-down> ]egv

        nmap <silent> t<C-n> :TestNearest<CR>
        nmap <silent> t<C-f> :TestFile<CR>

        " Scroll up/down lines from 'scroll' option, default half a screen
        map <C-j> <C-d>
        map <C-k> <C-u>

        " Save when ESC (well, ctrl-c) is pressed twice
        map <Esc><Esc> :w<CR>

        " Treat wrapped lines as normal lines
        nnoremap j gj
        nnoremap k gk

        " We don't need any help!
        inoremap <F1> <nop>
        nnoremap <F1> <nop>
        vnoremap <F1> <nop>

        " Open undo tree
        nnoremap <F1> :MundoToggle<CR>
        nnoremap <F2> :e .<CR>

        let g:mundo_width=35
        let g:mundo_preview_height=15
        let g:mundo_preview_bottom=1

        let g:hardtime_default_on = 1
        let g:hardtime_timeout = 500
        let g:hardtime_allow_different_key = 1
        let g:hardtime_maxcount = 3
        let g:hardtime_motion_with_count_resets = 1

        set diffopt+=iwhite
        set diffexpr=""

        set timeoutlen=400

        let g:limelight_conceal_ctermfg = 'gray'

        " Working ci(, works for both breaklined, inline and multiple ()
        nnoremap ci( %ci(

        " Disable annoying ex mode (Q)
        map Q <nop>

        " Buffers, preferred over tabs now with bufferline.
        nnoremap bn :BF<CR>
        nnoremap bN :BB<CR>
        nnoremap br :BD<CR>
        nnoremap bf <C-^>

        map *   <Plug>(asterisk-*)
        map #   <Plug>(asterisk-#)
        map g*  <Plug>(asterisk-g*)
        map g#  <Plug>(asterisk-g#)
        map z*  <Plug>(asterisk-z*)
        map gz* <Plug>(asterisk-gz*)
        map z#  <Plug>(asterisk-z#)
        map gz# <Plug>(asterisk-gz#)

        xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

        function! ExecuteMacroOverVisualRange()
            echo "@".getcmdline()
            execute ":'<,'>normal @".nr2char(getchar())
        endfunction

        let g:vdebug_keymap_defaults = {
        \    "run" : "<F5>",
        \    "run_to_cursor" : "<F9>",
        \    "step_over" : "<F2>",
        \    "step_into" : "<F3>",
        \    "step_out" : "<F4>",
        \    "close" : "<F6>",
        \    "detach" : "<F7>",
        \    "toggle_breakpoint" : "<F10>",
        \    "get_context" : "<F11>",
        \    "eval_under_cursor" : "<F12>",
        \    "eval_visual" : "<Leader>e"
        \}

        let g:bufferline_echo = 0

        " Easy motion mapping
        let g:EasyMotion_do_mapping = 0
        let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
        let g:EasyMotion_smartcase = 1

        nmap <C-p> :Files<CR>

        let g:rooter_patterns = ['Rakefile', '.git/', '.hg/']
    """ }}}
    """ Functions or fancy binds {{{{
        """ Toggle relativenumber using <leader>r {{{
            function! NumberToggle()
                if(&relativenumber == 1)
                    set number
                else
                    set relativenumber
                endif
            endfunction

            nnoremap <leader>r :call NumberToggle()<CR>
        """ }}}
        """ Remove multiple empty lines {{{
            function! DeleteMultipleEmptyLines()
                g/^\_$\n\_^$/d
            endfunction

            nnoremap <leader>ld :call DeleteMultipleEmptyLines()<CR>
        """ }}}
        """ Strip trailing whitespace, return to cursor at save {{{
            function! <SID>StripTrailingWhitespace()
                let l = line(".")
                let c = col(".")
                %s/\s\+$//e
                call cursor(l, c)
            endfunction

            augroup StripTrailingWhitespace
                autocmd!
                autocmd FileType c,cpp,conf,css,html,perl,python,sh,php
                            \ autocmd BufWritePre <buffer> :call
                            \ <SID>StripTrailingWhitespace()
            augroup END
        """ }}}
    """ }}}
""" }}}
""" Plugin settings {{{
    """ Lightline {{{
        let g:lightline = {
            \ 'colorscheme': 'gruvbox',
            \ 'active': {
            \     'left': [
            \         ['mode', 'paste'],
            \         ['readonly', 'fugitive']
            \     ],
            \     'right': [
            \         ['lineinfo'],
            \         ['percent'],
            \         ['fileformat', 'fileencoding', 'filetype', 'syntastic']
            \     ]
            \ },
            \ 'component': {
            \     'paste': '%{&paste?"!":""}',
            \     'readonly': '%{&readonly?"":""}',
            \     'bufferline': '%{bufferline#refresh_status()}%{MyBufferline()[0]}'.
            \                   '%#LightLineLeft_active_1#%{g:bufferline_status_info.current}'.
            \                   '%#LightLineLeft_active_2#%{MyBufferline()[2]}'
            \ },
            \ 'component_function': {
            \     'mode'         : 'MyMode',
            \     'fugitive'     : 'MyFugitive',
            \     'readonly'     : 'MyReadonly',
            \     'fileformat'   : 'MyFileformat',
            \     'fileencoding' : 'MyFileencoding',
            \     'filetype'     : 'MyFiletype'
            \ },
            \ 'component_expand': {
            \     'syntastic': 'SyntasticStatuslineFlag',
            \ },
            \ 'component_type': {
            \     'syntastic': 'middle',
            \ }
            \ }

        let g:airline#extensions#tabline#left_sep = ' '
        let g:airline#extensions#tabline#left_alt_sep = '|'

        let g:lightline.mode_map = {
            \ 'n'      : ' N ',
            \ 'i'      : ' I ',
            \ 'R'      : ' R ',
            \ 'v'      : ' V ',
            \ 'V'      : 'V-L',
            \ 'c'      : ' C ',
            \ "\<C-v>" : 'V-B',
            \ 's'      : ' S ',
            \ 'S'      : 'S-L',
            \ "\<C-s>" : 'S-B',
            \ '?'      : '      ' }

        function! MyReadonly()
            return &ft !~? 'help' && &readonly ? '≠' : '' " or ⭤
        endfunction

        function! MyBufferline()
            call bufferline#refresh_status()
            let b = g:bufferline_status_info.before
            let c = g:bufferline_status_info.current
            let a = g:bufferline_status_info.after
            let alen = strlen(a)
            let blen = strlen(b)
            let clen = strlen(c)
            let w = winwidth(0) * 4 / 11
            if w < alen+blen+clen
                let whalf = (w - strlen(c)) / 2
                let aa = alen > whalf && blen > whalf ? a[:whalf] : alen + blen < w - clen || alen < whalf ? a : a[:(w - clen - blen)]
                let bb = alen > whalf && blen > whalf ? b[-(whalf):] : alen + blen < w - clen || blen < whalf ? b : b[-(w - clen - alen):]
              return [(strlen(bb) < strlen(b) ? '...' : '') . bb, c, aa . (strlen(aa) < strlen(a) ? '...' : '')]
            else
              return [b, c, a]
            endif
        endfunction

        function! MyFileformat()
            return winwidth('.') > 90 ? &fileformat : ''
        endfunction

        function! MyFileencoding()
            return winwidth('.') > 80 ? (strlen(&fenc) ? &fenc : &enc) : ''
        endfunction

        function! MyFiletype()
            return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
        endfunction

        function! s:syntastic()
            SyntasticCheck
            call lightline#update()
        endfunction

        augroup AutoSyntastic
            autocmd!
            autocmd BufWritePost *.php,*.c,*.cpp,*.perl,*py call s:syntastic()
        augroup END
    """ }}}

    " Startify, the fancy start page
    let g:startify_change_to_vcs_root = 1
    let g:startify_fortune_use_unicode = 1

    " Syntastic - This is largely up to your own usage, and override these
    "             changes if be needed. This is merely an exemplification.
    let g:syntastic_cpp_check_header = 1
    let g:syntastic_cpp_compiler_options = ' -std=c++0x'
    let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
    let g:syntastic_mode_map = {
        \ 'mode': 'active',
        \ 'active_filetypes':
            \ ['c', 'cpp', 'perl', 'python', 'ruby', 'javascript', 'php'] }

    let g:syntastic_ruby_checkers = ['rubocop', 'mri']

    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 1

    let g:syntastic_php_checkers=['php', 'phpcs', 'phpstan', 'phpmd']
    let g:syntastic_php_phpcs_args='--standard=SHAKA -n'
    let g:syntastic_php_phpstan_post_args='--level 7'
    let g:syntastic_php_phpmd_post_args=expand('<sfile>:p:h')."/source/dotfiles/phpmd-ruleset.xml"
    let g:syntastic_aggregate_errors = 1
    let g:syntastic_always_populate_loc_list = 1

    let g:syntastic_javascript_checkers = ['jshint']
    let g:elm_syntastic_show_warnings = 1

    let g:racer_cmd = "~/source/racer/target/release/racer"
    let $RUST_SRC_PATH = $HOME."/source/rust/src"

    " Automatically remove preview window after autocomplete (mainly for clang_complete)
    augroup RemovePreview
        autocmd!
        autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
        autocmd InsertLeave * if pumvisible() == 0|pclose|endif
    augroup END

    if filereadable("coverage.vim")
      source coverage.vim
    endif

    if !exists('g:vdebug_options')
      let g:vdebug_options = {}
    endif

    let g:vdebug_options.break_on_open = 0
    let g:vdebug_options.watch_window_style = 'compact'
    let g:vdebug_options.watch_window_height = 50
    let g:vdebug_options.status_window_height = 5

    let g:deoplete#enable_at_startup = 1

    command! PadawanStart call deoplete#sources#padawan#StartServer()
    command! PadawanStop call deoplete#sources#padawan#StopServer()
    command! PadawanRestart call deoplete#sources#padawan#RestartServer()
    command! PadawanInstall call deoplete#sources#padawan#InstallServer()
    command! PadawanUpdate call deoplete#sources#padawan#UpdatePadawan()
    command! -bang PadawanGenerate call deoplete#sources#padawan#Generate(<bang>0)

    autocmd BufReadPost *.rs setlocal filetype=rust
""" }}}
