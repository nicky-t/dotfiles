call plug#begin('~/.config/nvim/plugged')
    Plug 'justinmk/vim-sneak'
        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
        let g:sneak#label = 1

    " VSCodeでは使わずVimだけに反映させたい設定の記述
    if !exists('g:vscode')
        Plug 'preservim/nerdtree'
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " ファイル検索
        Plug 'junegunn/fzf.vim'
    end

    Plug 'tpope/vim-commentary' " visual modeに移動して、gcでコメントアウトが可能
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
        function! s:on_lsp_buffer_enabled() abort
            setlocal omnifunc=lsp#complete
            setlocal signcolumn=yes
            if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
            nmap <buffer> gd <plug>(lsp-definition)
           nmap buffer> <leader>rn <plug>(lsp-rename)
            nmap <buffer> [g <plg>(lsp-previous-diagnostic)
            nmap <buffer> ]g <plug>(lsp-next-diagnostic)
            nmap <buffer> ga <plug>(lsp-code-action)
            nmap <buffer> K <plug>(lsp-hover)
            inoremap <buffer> <expr><c-f> lsp#scroll(+4)
            inoremap <buffer> <expr><c-d> lsp#scroll(-4)

            let g:lsp_format_sync_timeout = 1000
            autocmd! BufWritePre .tsx,.ts,.rs,.go call execute('LspDocumentFormatSync')

        endfunction

        augroup lsp_install
            au!
            autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
        augroup END

    Plug 'tomasr/molokai'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'ryanoasis/vim-devicons'
    Plug 'machakann/vim-highlightedyank'
call plug#end()

" NERDTree SETTINGS
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Airline SETTINGS
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
nmap <C-p> <Plug>AirlineSelectPrevTab
nmap <C-n> <Plug>AirlineSelectNextTab

colorscheme molokai

set shell=/usr/local/bin/zsh " コマンドの際にはzshを使う
set tabstop=2 " タブに変換されるサイズ
set shiftwidth=2 " Indentの幅
set expandtab " タブの入力の際にスペース
set textwidth=0 " ワードラッピング無し
set smarttab
set clipboard=unnamedplus " クリップボードへの登録
set number " 行番号を表示
set hlsearch " 検索結果のハイライト
set ignorecase " 検索パターンにおいて大文字と小文字を区別しない
set incsearch " 検索コマンドを打ち込んでる間にも、打ち込んだところまで検査結果を表示する
set belloff=all " ビープ音を消す

" 削除キーでyankしない
nnoremap x "_x
nnoremap D "_D

vnoremap x "_x

inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

