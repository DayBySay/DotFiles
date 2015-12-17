set encoding=utf-8
scriptencoding utf-8
syntax on

" Display
set number "行番号を表示
set nolist "改行を非表示
set laststatus=2 "ステータスの表示位置
set showcmd "コマンドをステータス行に表示
set title "タイトルバーの表示設定
set cursorline "カーソルの行位置の表示設定

" Tab settings
set tabstop=4 "タブの画面上の幅
set softtabstop=4 "タブを空白の何も自分にするか設定
set expandtab "タブをスペースに展開する

"set expandtab
set shiftwidth=4 "自動インデントで挿入されるスペース
set shiftround "インデントをオプション 'shiftwidth' の値の倍数に丸める。

" Editing
set autoindent "自動インデント設定
set smartindent "改行に合わせたインデント設定
set showmatch "括弧入力時に対応した閉じ括弧を入力
set backspace=indent,eol,start "バックスペースでインデントなどを削除できるよう設定
set matchpairs+=<:> "%入力時に対応した括弧へ移動

" Backup
set nobackup
set noswapfile
set nowritebackup

" Search
set incsearch "インクリメンタルサーチ
set hlsearch "検索結果のハイライト
highlight Search ctermbg=4 "ハイライトの色設定
set ignorecase "大文字小文字を区別しない
set smartcase "検索パターンに大文字を含んだ場合大文字小文字を区別する

"Escの2回押しでハイライト消去
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" quit
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-q> :q<CR>

" 改行コードの自動認識
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif

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


" plugins
"" NeoBundle
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" Installation check.
if neobundle#exists_not_installed_bundles()
    echomsg 'Not installed bundles : ' .
                \ string(neobundle#get_not_installed_bundle_names())
    echomsg 'Please execute ":NeoBundleInstall" command.'
    "finish
endif

"" Unite
NeoBundle 'Shougo/unite.vim'
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>

"" vimproc
NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
        \     'windows' : 'tools\\update-dll-mingw',
        \     'cygwin' : 'make -f make_cygwin.mak',
        \     'mac' : 'make',
        \     'linux' : 'make',
        \     'unix' : 'gmake',
        \    },
        \ }

" wbapi
NeoBundle 'mattn/webapi-vim'

" snippet
if has('lua') && (( v:version == 703 && has('patch885')) || (v:version >= 704))
  NeoBundle 'Shougo/neocomplete'
else
  NeoBundle 'Shougo/neocomplcache'
endif
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle "honza/vim-snippets"

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" 自分用 snippet ファイルの場所
let s:my_snippet = '~/DotFiles/snippets/'
let g:neosnippet#snippets_directory = s:my_snippet

" execute shell script for vim
NeoBundle 'Shougo/vimshell'

" multiple function selector
NeoBundle 'kien/ctrlp.vim'

" accept filetype json
NeoBundle 'JSON.vim'
au! BufRead,BufNewFile *.json set filetype=json

" Show dir list
NeoBundle 'scrooloose/nerdtree'

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

" Auto close 
NeoBundle 'Townk/vim-autoclose'

" git command interface for vim 
NeoBundle 'tpope/vim-fugitive'

" check syntacs auto
NeoBundle 'scrooloose/syntastic'

" end plugins
call neobundle#end()

NeoBundleCheck
filetype plugin indent on
