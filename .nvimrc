"-----------------------------------------------"
" Author:       Tim Sæterøy                     "
" Homepage:     http://thevoid.no               "
" Source:       http://github.com/timss/vimconf "
"-----------------------------------------------"

" vimconf is not vi-compatible
set nocompatible

""" Automatically make needed files and folders on first run
""" If you don't run *nix you're on your own (as in remove this) {{{
    call system("mkdir -p $HOME/.nvim/{swap,undo}")
    if !filereadable($HOME . "/.nvimrc.plugins") | call system("touch $HOME/.nvimrc.plugins") | endif
    if !filereadable($HOME . "/.nvimrc.first") | call system("touch $HOME/.nvimrc.first") | endif
    if !filereadable($HOME . "/.nvimrc.last") | call system("touch $HOME/.nvimrc.last") | endif
""" }}}
""" Vundle plugin manager {{{
    """ Automatically setting up Vundle, taken from
    """ http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/ {{{
        let has_vundle=1
        if !filereadable($HOME."/.nvim/bundle/Vundle.vim/README.md")
            echo "Installing Vundle..."
            echo ""
            silent !mkdir -p $HOME/.nvim/bundle
            silent !git clone https://github.com/gmarik/Vundle.vim $HOME/.nvim/bundle/Vundle.vim
            let has_vundle=0
        endif
    """ }}}
    """ Initialize Vundle {{{
        filetype off                                " required to init
        set rtp+=$HOME/.nvim/bundle/Vundle.vim       " include vundle
        call vundle#begin()                         " init vundle
    """ }}}
    """ Github repos, uncomment to disable a plugin {{{
    Plugin 'gmarik/Vundle.vim'

    """ Local plugins (and only plugins in this file!) {{{{
        if filereadable($HOME."/.nvimrc.plugins")
            source $HOME/.nvimrc.plugins
        endif
    """ }}}

    " <Tab> everything!
    Plugin 'ervandew/supertab'

    " Fuzzy finder (files, mru, etc)
    Plugin 'kien/ctrlp.vim'

    " A pretty statusline, bufferline integration
    Plugin 'itchyny/lightline.vim'
    Plugin 'bling/vim-bufferline'

    " Easy... motions... yeah.
    Plugin 'Lokaltog/vim-easymotion'

    " Glorious colorschemes
    Plugin 'nanotech/jellybeans.vim'
    Plugin 'tshakah/gruvbox'

    " Super easy commenting, toggle comments etc
    Plugin 'scrooloose/nerdcommenter'

    " Autoclose (, " etc
    Plugin 'Townk/vim-autoclose'

    " Git wrapper inside Vim
    Plugin 'tpope/vim-fugitive'

    " Handle surround chars like ''
    Plugin 'tpope/vim-surround'

    " Align your = etc.
    Plugin 'vim-scripts/Align'

    " Snippets like textmate
    Plugin 'MarcWeber/vim-addon-mw-utils'
    Plugin 'tomtom/tlib_vim'
    Plugin 'honza/vim-snippets'
    Plugin 'garbas/vim-snipmate'

    " A fancy start screen, shows MRU etc.
    Plugin 'mhinz/vim-startify'

    " Vim signs (:h signs) for modified lines based off VCS (e.g. Git)
    Plugin 'airblade/vim-gitgutter'

    " Awesome syntax checker.
    " REQUIREMENTS: See :h syntastic-intro
    Plugin 'scrooloose/syntastic'
    Plugin 'wting/rust.vim'
    Plugin 'Shutnik/jshint2.vim'

    " Functions, class data etc.
    " REQUIREMENTS: (exuberant)-ctags
    Plugin 'majutsushi/tagbar'

    " Detect whitespace
    Plugin 'ntpeters/vim-better-whitespace'

    " Code analysis
    Plugin 'ngmy/vim-rubocop'

    " End completion
    Plugin 'tpope/vim-endwise'

    " Shell commands
    Plugin 'tpope/vim-eunuch'

    " RACER!
    Plugin 'phildawes/racer'

    " Unimpaired vim!
    Plugin 'tpope/vim-unimpaired'

    " Undo tree
    Plugin 'mbbill/undotree'

    " Finish Vundle stuff
    call vundle#end()

    """ Installing plugins the first time, quits when done {{{
        if has_vundle == 0
            :silent! PluginInstall
            :qa
        endif
    """ }}}
""" }}}
""" Local leading config, only use for prerequisites as it will be
""" overwritten by anything below {{{{
    if filereadable($HOME."/.nvimrc.first")
        source $HOME/.nvimrc.first
    endif
""" }}}
""" User interface {{{
    """ Syntax highlighting {{{
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
                highlight CursorLine ctermbg=235
            endfunction

            call CustomHighlighting()
        """ }}}
    """ }}}
    """ Interface general {{{
        set cursorline                              " hilight cursor line
        set more                                    " ---more--- like less
        set number                                  " line numbers
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
    set ttymouse=xterm2                             " experimental
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
    set autochdir                                   " always use curr. dir.
    set autoread                                    " refresh if changed
    set confirm                                     " confirm changed files
    set noautowrite                                 " never autowrite
    set nobackup                                    " disable backups
    """ Persistent undo. Requires Vim 7.3 {{{
        if has('persistent_undo') && exists("&undodir")
            set undodir=$HOME/.nvim/undo/            " where to store undofiles
            set undofile                            " enable undofile
            set undolevels=500                      " max undos stored
            set undoreload=10000                    " buffer stored undos
        endif
    """ }}}
    """ Swap files, unless vim is invoked using sudo. Inspired by tejr's vimrc
    """ https://github.com/tejr/dotfiles/blob/master/vim/vimrc {{{
        if !strlen($SUDO_USER)
            set directory^=$HOME/.nvim/swap//        " default cwd, // full path
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
    set shiftwidth=2                                " default 8
    set smartcase                                   " sensitive with uppercase
    set smarttab                                    " tab to 0,4,8 etc.
    set softtabstop=2                               " "tab" feels like <tab>
    set tabstop=2                                   " replace <TAB> w/4 spaces
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
""" }}}
""" Keybindings {{{
    """ General {{{
        " Remap <leader>
        let mapleader=","

        " Quickly edit/source .vimrc
        noremap <leader>ve :edit $HOME/.nvimrc<CR>
        noremap <leader>vs :source $HOME/.nvimrc<CR>

        " Yank(copy) to system clipboard
        noremap <leader>y "+y

        " Bubbling (bracket matching)
        nmap <C-up> [e
        nmap <C-down> ]e
        vmap <C-up> [egv
        vmap <C-down> ]egv

        " Scroll up/down lines from 'scroll' option, default half a screen
        map <C-j> <C-d>
        map <C-k> <C-u>

        " Save when ESC (well, ctrl-c) is pressed twice
        map <C-c><C-c> :w<CR>

        " Treat wrapped lines as normal lines
        nnoremap j gj
        nnoremap k gk

        " Open undo tree
        nnoremap <F5> :UndotreeToggle<CR>

        " Working ci(, works for both breaklined, inline and multiple ()
        nnoremap ci( %ci(

        " We don't need any help!
        inoremap <F1> <nop>
        nnoremap <F1> <nop>
        vnoremap <F1> <nop>

        " Disable annoying ex mode (Q)
        map Q <nop>

        " Buffers, preferred over tabs now with bufferline.
        nnoremap gn :bnext<CR>
        nnoremap gN :bprevious<CR>
        nnoremap gr :bdelete<CR>
        nnoremap gf <C-^>

        let g:bufferline_echo = 0

        " Easy motion mapping
        let g:EasyMotion_do_mapping = 0
        let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
        let g:EasyMotion_smartcase = 1

        nmap <Space>s <Plug>(easymotion-s2)
        map  / <Plug>(easymotion-sn)
        nmap / <Plug>(easymotion-sn)
        xmap / <Esc><Plug>(easymotion-sn)\v%V
        omap / <Plug>(easymotion-tn)
        nnoremap g/ /
          " These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
          " Without these mappings, `n` & `N` works fine. (These mappings just provide
          " different highlight method and have some other features )
        map  n <Plug>(easymotion-next)
        map  N <Plug>(easymotion-prev)
        map <Space>l <Plug>(easymotion-lineforward)
        map <Space>j <Plug>(easymotion-j)
        map <Space>k <Plug>(easymotion-k)
        map <Space>h <Plug>(easymotion-linebackward)

    """ }}}
    """ Functions or fancy binds {{{{
        """ Toggle syntax highlighting {{{
            function! ToggleSyntaxHighlighthing()
                if exists("g:syntax_on")
                    syntax off
                else
                    syntax on
                    call CustomHighlighting()
                endif
            endfunction

            nnoremap <leader>s :call ToggleSyntaxHighlighthing()<CR>
        """ }}}
        """ Highlight characters past 79, toggle with <leader>h
        """ You might want to override this function and its variables with
        """ your own in .vimrc.last which might set for example colorcolumn or
        """ even the textwidth. See https://github.com/timss/vimconf/pull/4 {{{
            let g:overlength_enabled = 0
            highlight OverLength ctermbg=238 guibg=#444444

            function! ToggleOverLength()
                if g:overlength_enabled == 0
                    match OverLength /\%79v.*/
                    let g:overlength_enabled = 1
                    echo 'OverLength highlighting turned on'
                else
                    match
                    let g:overlength_enabled = 0
                    echo 'OverLength highlighting turned off'
                endif
            endfunction

            nnoremap <leader>h :call ToggleOverLength()<CR>
        """ }}}
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
        """ Toggle text wrapping, wrap on whole words
        """ For more info see: http://stackoverflow.com/a/2470885/1076493 {{{
            function! WrapToggle()
                if &wrap
                    set list
                    set nowrap
                else
                    set nolist
                    set wrap
                endif
            endfunction

            nnoremap <leader>w :call WrapToggle()<CR>
        """ }}}
        """ Remove multiple empty lines {{{
            function! DeleteMultipleEmptyLines()
                g/^\_$\n\_^$/d
            endfunction

            nnoremap <leader>ld :call DeleteMultipleEmptyLines()<CR>
        """ }}}
        """ Split to relative header/source {{{
            function! SplitRelSrc()
                let s:fname = expand("%:t:r")

                if expand("%:e") == "h"
                    set nosplitright
                    exe "vsplit" fnameescape(s:fname . ".cpp")
                    set splitright
                elseif expand("%:e") == "cpp"
                    exe "vsplit" fnameescape(s:fname . ".h")
                endif
            endfunction

            nnoremap <leader>le :call SplitRelSrc()<CR>
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
                autocmd FileType c,cpp,conf,css,html,perl,python,sh
                            \ autocmd BufWritePre <buffer> :call
                            \ <SID>StripTrailingWhitespace()
            augroup END
        """ }}}
    """ }}}
    """ Plugins {{{
        " Toggle tagbar (definitions, functions etc.)
        map <F2> :TagbarToggle<CR>

        " Intelligent paste
        let &t_SI .= "\<Esc>[?2004h"
        let &t_EI .= "\<Esc>[?2004l"
        inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
        function! XTermPasteBegin()
            set pastetoggle=<Esc>[201~
            set paste
            set copyindent
            return ""
        endfunction

        " Syntastic - toggle error list. Probably should be toggleable.
        noremap <silent><leader>lo :Errors<CR>
        noremap <silent><leader>lc :lcl<CR>
    """ }}}
""" }}}
""" Plugin settings {{{
    """ Lightline {{{
        let g:lightline = {
            \ 'colorscheme': 'gruvbox',
            \ 'active': {
            \     'left': [
            \         ['mode', 'paste'],
            \         ['readonly', 'fugitive'],
            \         ['ctrlpmark', 'bufferline']
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
            \     'ctrlpmark'    : 'CtrlPMark',
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

        function! MyMode()
            let fname = expand('%:t')
            return fname == '__Tagbar__' ? 'Tagbar' :
                    \ fname == 'ControlP' ? 'CtrlP' :
                    \ winwidth('.') > 60 ? lightline#mode() : ''
        endfunction

        function! MyFugitive()
            try
                if expand('%:t') !~? 'Tagbar' && exists('*fugitive#head')
                    let mark = '± '
                    let _ = fugitive#head()
                    return strlen(_) ? mark._ : ''
                endif
            catch
            endtry
            return ''
        endfunction

        function! MyReadonly()
            return &ft !~? 'help' && &readonly ? '≠' : '' " or ⭤
        endfunction

        function! CtrlPMark()
            if expand('%:t') =~ 'ControlP'
                call lightline#link('iR'[g:lightline.ctrlp_regex])
                return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                    \ , g:lightline.ctrlp_next], 0)
            else
                return ''
            endif
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

        let g:ctrlp_status_func = {
            \ 'main': 'CtrlPStatusFunc_1',
            \ 'prog': 'CtrlPStatusFunc_2',
            \ }

        function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
            let g:lightline.ctrlp_regex = a:regex
            let g:lightline.ctrlp_prev = a:prev
            let g:lightline.ctrlp_item = a:item
            let g:lightline.ctrlp_next = a:next
            return lightline#statusline(0)
        endfunction

        function! CtrlPStatusFunc_2(str)
            return lightline#statusline(0)
        endfunction

        let g:tagbar_status_func = 'TagbarStatusFunc'

        function! TagbarStatusFunc(current, sort, fname, ...) abort
            let g:lightline.fname = a:fname
            return lightline#statusline(0)
        endfunction

        function! s:syntastic()
            SyntasticCheck
            call lightline#update()
        endfunction

        augroup AutoSyntastic
            autocmd!
            autocmd BufWritePost *.c,*.cpp,*.perl,*py call s:syntastic()
        augroup END
    """ }}}

    " Startify, the fancy start page
    let g:ctrlp_reuse_window = 'startify' " don't split in startify
    let g:startify_bookmarks = [
        \ $HOME . "/.nvimrc", $HOME . "/.nvimrc.first",
        \ $HOME . "/.nvimrc.last", $HOME . "/.nvimrc.plugins"
        \ ]
    let g:startify_custom_header = [
        \ '   Author:      Tim Sæterøy',
        \ '   Homepage:    http://thevoid.no',
        \ '   Source:      http://github.com/timss/vimconf',
        \ ''
        \ ]

    " CtrlP - don't recalculate files on start (slow)
    let g:ctrlp_clear_cache_on_exit = 0
    let g:ctrlp_working_path_mode = 'ra'

    " TagBar
    let g:tagbar_left = 0
    let g:tagbar_width = 30
    set tags=tags;/

    " Syntastic - This is largely up to your own usage, and override these
    "             changes if be needed. This is merely an exemplification.
    let g:syntastic_cpp_check_header = 1
    let g:syntastic_cpp_compiler_options = ' -std=c++0x'
    let g:syntastic_mode_map = {
        \ 'mode': 'passive',
        \ 'active_filetypes':
            \ ['c', 'cpp', 'perl', 'python'] }

    " Netrw - the bundled (network) file and directory browser
    let g:netrw_banner = 0
    let g:netrw_list_hide = '^\.$'
    let g:netrw_liststyle = 3

    let g:solarized_termcolors = 256

    let jshint2_save = 1

    let g:racer_cmd = "~/source/racer/target/release/racer"
    let $RUST_SRC_PATH = "/home/dan/source/rust-lang/src"

    " Automatically remove preview window after autocomplete (mainly for clang_complete)
    augroup RemovePreview
        autocmd!
        autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
        autocmd InsertLeave * if pumvisible() == 0|pclose|endif
    augroup END
""" }}}
""" Local ending config, will overwrite anything above. Generally use this. {{{{
    if filereadable($HOME."/.nvimrc.last")
        source $HOME/.nvimrc.last
    endif
""" }}}
