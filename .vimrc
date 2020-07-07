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

" vimgrep
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ
set grepprg=grep\ -rnIH\ --exclude-dir=.svn\ --exclude-dir=.git
autocmd QuickfixCmdPost vimgrep copen
autocmd QuickfixCmdPost grep copen
nnoremap <expr> <Space>g ':vimgrep /\<' . expand('<cword>') . '\>/j **/*'
nnoremap <expr> <Space>G ':sil grep! ' . expand('<cword>') . ' *'

" 改行コードの自動認識
set fileformats=unix,dos,mac

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif

" vimの補完機能設定
set completeopt=menuone,preview

filetype plugin indent on
