au! BufNewFile,BufRead *.tpl setf html
au! BufRead,BufNewFile *.tpl setf smarty
au! BufNewFile,BufRead *.ini setf php
au! BufNewFile,BufRead *.diag setf diag

autocmd filetype php :set makeprg=php\ -l\ %
autocmd filetype php :set errorformat=%m\ in\ %f\ on\ line\ %l

syntax on

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

" 文字コードの自動認識
if &encoding !=# 'utf-8'
set encoding=japan
set fileencoding=japan
endif
if has('iconv')
let s:enc_euc = 'euc-jp'
let s:enc_jis = 'iso-2022-jp'
" iconvがeucJP-msに対応しているかをチェック
if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
let s:enc_euc = 'eucjp-ms'
let s:enc_jis = 'iso-2022-jp-3'
" iconvがJISX0213に対応しているかをチェック
elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
let s:enc_euc = 'euc-jisx0213'
let s:enc_jis = 'iso-2022-jp-3'
endif
" fileencodingsを構築
if &encoding ==# 'utf-8'
let s:fileencodings_default = &fileencodings
let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
let &fileencodings = &fileencodings .','. s:fileencodings_default
unlet s:fileencodings_default
else
let &fileencodings = &fileencodings .','. s:enc_jis
set fileencodings+=utf-8,ucs-2le,ucs-2
if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
set fileencodings+=cp932
set fileencodings-=euc-jp
set fileencodings-=euc-jisx0213
set fileencodings-=eucjp-ms
let &encoding = s:enc_euc
let &fileencoding = s:enc_euc
else
let &fileencodings = &fileencodings .','. s:enc_euc
endif
endif
" 定数を処分
unlet s:enc_euc
unlet s:enc_jis
endif
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


" for quickrun
filetype plugin on  

" init
let g:quickrun_config={}

" 横分割をするようにする
let g:quickrun_config={'*': {'split': ''}}

" 横分割時は下へ､ 縦分割時は右へ新しいウィンドウが開くようにする
set splitbelow
set splitright

" blockdiag
let g:quickrun_config['diag'] = {
            \'command': 'blockdiag',
            \'exec': ['%c -a %s -o %{expand("%:r")}.png', 'open -g  %{expand("%:r")}.png'],
            \'outputter':'message',
            \}

" php-doc
inoremap <C-@> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-@> :call PhpDocSingle()<CR>
vnoremap <C-@> :call PhpDocRange()<CR>

set nocompatible               " be iMproved
filetype off


"--------------------------------------------------------------------------
" neobundle
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


" originalrepos on github
NeoBundle 'Shougo/neobundle.vim'
" 
NeoBundle 'Shougo/vimproc'
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
    " 新しく追加した neocomplete の設定
else
    " 今までの neocomplcache の設定
endif

" Required:
 filetype plugin indent on


NeoBundleCheck

nnoremap <expr> c* ':%s ;\<' . expand('<cword>') . '\>;'
vnoremap <expr> c* ':s ;\<' . expand('<cword>') . '\>

filetype plugin indent on     " required!
filetype indent on
syntax on
" vi上から、:NeoBundleInstallで.vimrcのNeoBundleで指定されているリポジトリのプラグインをインストールできる。
" プラグインを削除したい場合は、vimrc上からNeoBundleの記述を消して:NeoBundleCleanでできる。

"call pathogen#infect()
