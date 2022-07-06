" python bug in 3.7.0
if has('python3')
  silent! python3 1
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle

set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

call vundle#end()             " required
filetype plugin indent on     " required

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plugin 'Valloric/YouCompleteMe'
Plugin 'tmhedberg/SimpylFold'               " folding definitions
	let g:SimpylFold_docstring_preview = 1
Plugin 'tell-k/vim-autopep8'
    autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
    let g:autopep8_disable_show_diff=1      " suppress diff window as every time running
	let g:autopep8_aggressive=2             " aggressive level
	" let g:autopep8_on_save = 1              " on save
Plugin 'scrooloose/nerdcommenter'
    let g:NERDSpaceDelims = 1
  	let g:NERDCompactSexyComs = 1
  	let g:NERDDefaultAlign = 'left'
  	let g:NERDAltDelims_java = 1
  	let g:NERDCustomDelimiters = { 'c': { 'left': '# ','right': '' } }
  	let g:NERDCommentEmptyLines = 1
    let g:NERDTrimTrailingWhitespace = 1
Plugin 'scrooloose/nerdtree'
    map <F2> :NERDTreeToggle<CR>
  	let NERDTreeChDirMode=1
    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
    let NERDTreeWinSize=25
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Plugin 'powerline/powerline'              " too hard to install
" Plugin 'vim-airline/vim-airline'          " so-so status line
" Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-surround'
Plugin 'itchyny/lightline.vim'
	let g:lightline = {
		\ 'colorscheme': 'wombat',
		\ 'active': {
		\   'left': [ [ 'mode', 'paste' ],
		\             [ 'readonly', 'filename', 'modified', 'charvaluehex' ] ]
		\ },
		\ 'component': {
		\   'charvaluehex': '0x%B'
		\ },
		\ }
Plugin 'terryma/vim-multiple-cursors'
	let g:multi_cursor_use_default_mapping=0

	" Default mapping
	let g:multi_cursor_start_word_key      = '<C-n>'
	let g:multi_cursor_select_all_word_key = '<A-n>'
	let g:multi_cursor_start_key           = 'g<C-n>'
	let g:multi_cursor_select_all_key      = 'g<A-n>'
	let g:multi_cursor_next_key            = '<C-n>'
	let g:multi_cursor_prev_key            = '<C-p>'
	let g:multi_cursor_skip_key            = '<C-x>'
	let g:multi_cursor_quit_key            = '<Esc>'
" Plugin 'vim-python/python-syntax'       " no effects
"     let g:python_highlight_all = 1
Plugin 'nvie/vim-flake8'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'ap/vim-buftabline'
	set hidden
	" nnoremap <C-N> :bnext<CR>
	" nnoremap <C-P> :bprev<CR>
	nnoremap H :tabprev<CR>
	nnoremap L :tabnext<CR>
Plugin 'majutsushi/tagbar'              " 'brew install ctags' needed
	nnoremap <C-T> :TagbarToggle<CR> 
Plugin 'moll/vim-node'


" Themes
Plugin 'dracula/vim'
	color dracula
Plugin 'rakr/vim-one'
	colors one
Plugin 'tomasr/molokai'
	colors molokai

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on

set t_Co=256
set autoread
set background=dark
set backspace=2
set cindent                   " indent as C lang
set clipboard=unnamed         " enable clipboard and so do hot-heys
set cursorcolumn
set cursorline
set encoding=utf-8
set fenc=utf-8
set fileformat=unix           " save as unix format
set guifont=Monaco:h13        " fonts
set hlsearch                  " highlight search
set ignorecase
set incsearch
set laststatus=2
set matchtime=5
set mouse=a                   " enable mouse (?
set noexpandtab
set nowrap
set number                    " number of line
set scrolloff=5
set selection=exclusive
set selectmode=mouse,key
set shiftwidth=4
set showcmd
set showmatch                 " show paired paretheses
set showtabline=0
set tabstop=4
set whichwrap+=<,>,h,l

highlight Comment cterm=bold ctermfg=005        " settings of comments
    " refer the palette to https://github.com/gawin/bash-colors-256
highlight Visual guibg=Grey ctermbg=Grey

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <F5> :w<CR> :call RunPython()<CR>
function RunPython()
    let mp = &makeprg
    let ef = &errorformat
    let exeFile = expand("%:t")
    setlocal makeprg=python\ -u
    set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    silent make %
    copen
    let &makeprg = mp
    let &errorformat = ef
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" make sure the beviours of specified extension
au BufNewFile,BufRead *.py  
    \ set tabstop=4         |
    \ set softtabstop=4     |
    \ set shiftwidth=4      |
    \ set textwidth=79      |
    \ set expandtab         |
    \ set autoindent        

au BufNewFile,BufRead *.js,*.html,*.css,*.yml,*.md 
    \ set expandtab         |
    \ set tabstop=2         |
    \ set softtabstop=2     |
    \ set shiftwidth=2
