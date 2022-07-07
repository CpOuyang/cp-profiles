"""""""""""""""""""""""""""""""""""""""""""""""""
" Variables settings
"""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set clipboard=unnamed
set nowrap
set number

"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings by vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'preservim/nerdtree'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
