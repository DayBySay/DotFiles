set encoding=utf-8
scriptencoding utf-8

au! BufNewFile,BufRead *.tpl setf html
au! BufRead,BufNewFile *.tpl setf smarty
au! BufNewFile,BufRead *.ini setf php
au! BufNewFile,BufRead *.diag setf diag

autocmd filetype php :set makeprg=php\ -l\ %
autocmd filetype php :set errorformat=%m\ in\ %f\ on\ line\ %l

" Display
set number
set nolist
set laststatus=2
"set textwidth=78
set showcmd
set title
set cursorline

" Editing
set autoindent
set smartindent
set showmatch
set backspace=indent,eol,start
set matchpairs+=<:>

" Status line
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]\ %F%m%r%h%w[%{&ff}]%=%{g:NyanModoki()}(%l,%c)[%P]

let g:nyan_modoki_select_cat_face_number = 2
let g:nayn_modoki_animation_enabled= 1

" Others
set nobackup
set noswapfile
set nowritebackup

" Perltidy
" map ,ptv <Esc>:'<,'>! perltidy<CR>

" Tab settings
set tabstop=4
set softtabstop=4
set expandtab

"set expandtab
set shiftwidth=4
set shiftround

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase

"Escの2回押しでハイライト消去
nmap <Esc><Esc> :nohlsearch<CR><Esc>

set backspace=indent,eol,start

set filetype=html

highlight Search ctermbg=4

" quit
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-q> :q<CR>

" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" 改行コードの自動認識
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
function InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>



"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
" for quickrun
filetype plugin on  

" init
let g:quickrun_config={}


"--------------------------------------------------------------------------
" 
"--------------------------------------------------------------------------
" 横分割をするようにする
let g:quickrun_config={'*': {'split': ''}}

" 横分割時は下へ､ 縦分割時は右へ新しいウィンドウが開くようにする
set splitbelow
set splitright


"--------------------------------------------------------------------------
" blockdiag
"--------------------------------------------------------------------------
let g:quickrun_config['diag'] = {
            \'command': 'blockdiag',
            \'exec': ['%c -a %s -o %{expand("%:r")}.png', 'open -g  %{expand("%:r")}.png'],
            \'outputter':'message',
            \}


"--------------------------------------------------------------------------
" php-doc
"--------------------------------------------------------------------------
inoremap <C-@> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-@> :call PhpDocSingle()<CR>
vnoremap <C-@> :call PhpDocRange()<CR>

set nocompatible               " be iMproved
filetype off


"--------------------------------------------------------------------------
" NERDTree
"--------------------------------------------------------------------------
" 引数なしで実行したとき、NERDTreeを実行する
let file_name = expand("%:p")
if has('vim_starting') &&  file_name == ""
    autocmd VimEnter * call ExecuteNERDTree()
endif

" カーソルが外れているときは自動的にnerdtreeを隠す
function! ExecuteNERDTree()
    "b:nerdstatus = 1 : NERDTree 表示中
    "b:nerdstatus = 2 : NERDTree 非表示中

    if !exists('g:nerdstatus')
        execute 'NERDTree ./'
        let g:windowWidth = winwidth(winnr())
        let g:nerdtreebuf = bufnr('')
        let g:nerdstatus = 1 

    elseif g:nerdstatus == 1 
        execute 'wincmd t'
        execute 'vertical resize' 0 
        execute 'wincmd p'
        let g:nerdstatus = 2 
    elseif g:nerdstatus == 2 
        execute 'wincmd t'
        execute 'vertical resize' g:windowWidth
        let g:nerdstatus = 1 

    endif
endfunction
noremap <c-e> :<c-u>:call ExecuteNERDTree()<cr>


"--------------------------------------------------------------------------
" syntastic
"--------------------------------------------------------------------------
let g:syntastic_python_checkers = ["flake8"]


"--------------------------------------------------------------------------
" neobundle
"--------------------------------------------------------------------------
set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Installation check.
if neobundle#exists_not_installed_bundles()
    echomsg 'Not installed bundles : ' .
                \ string(neobundle#get_not_installed_bundle_names())
    echomsg 'Please execute ":NeoBundleInstall" command.'
    "finish
endif

syntax on

" originalrepos on github
NeoBundle 'Shougo/neobundle.vim'
" 
NeoBundle 'Shougo/vimproc'
" snippet
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
" 
NeoBundle 'VimClojure'
" execute shell script for vim
NeoBundle 'Shougo/vimshell'
" multiple function selector
NeoBundle 'kien/ctrlp.vim'
"
NeoBundle 'Shougo/unite.vim'
" ?
NeoBundle 'jpalardy/vim-slime'
" check syntacs auto
NeoBundle 'scrooloose/syntastic'
" JSON syntax editer
"NeoBundle '5t111111/neat-json.vim'
" git command interface for vim 
NeoBundle 'tpope/vim-fugitive'
" Show dir list
NeoBundle 'scrooloose/nerdtree'
" Auto close 
NeoBundle 'Townk/vim-autoclose'
" run script on vim
NeoBundle 'thinca/vim-quickrun'
" grep benri
NeoBundle 'grep.vim'
" kawaii
NeoBundle 'drillbits/nyan-modoki.vim'
" flake8
NeoBundle 'nvie/vim-flake8'

" accept filetype json
NeoBundle 'JSON.vim'
au! BufRead,BufNewFile *.json set filetype=json

" auto complete
function! s:meet_neocomplete_requirements()
    return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

if s:meet_neocomplete_requirements()
    NeoBundle 'Shougo/neocomplete.vim'
    NeoBundleFetch 'Shougo/neocomplcache.vim'
else
    NeoBundleFetch 'Shougo/neocomplete.vim'
    NeoBundle 'Shougo/neocomplcache.vim'
endif
if s:meet_neocomplete_requirements()
    " 新しく追加 neocomplete の設定
else
    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplcache.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    let g:neocomplcache_enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplcache_min_syntax_length = 3
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
    " Define dictionary.

    let g:neocomplcache_dictionary_filetype_lists = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplcache#undo_completion()
    inoremap <expr><C-l>     neocomplcache#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        return neocomplcache#smart_close_popup() . "\<CR>"
        " For no inserting <CR> key.
        "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplcache#close_popup()
    inoremap <expr><C-e>  neocomplcache#cancel_popup()

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_force_omni_patterns')
        let g:neocomplcache_force_omni_patterns = {}
    endif
    let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplcache_force_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
endif

" Required:
filetype plugin indent on


NeoBundleCheck

nnoremap <expr> c* ':%s ;\<' . expand('<cword>') . '\>;'
vnoremap <expr> c* ':s ;\<' . expand('<cword>') . '\>

filetype plugin indent on     " required!
filetype indent on
" vi上から、:NeoBundleInstallで.vimrcのNeoBundleで指定されているリポジトリのプラグインをインストールできる。
" プラグインを削除したい場合は、vimrc上からNeoBundleの記述を消して:NeoBundleCleanでできる。


"--------------------------------------------------------------------------
" NeoSnnipet
"--------------------------------------------------------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)"
            \: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
