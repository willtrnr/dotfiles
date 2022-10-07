" Use the standard vim paths
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Enable true-color mode
set termguicolors

" Include the common vimrc file first
source ~/.vimrc

" Set terminal scrollback much lower to avoid lag issues
set scrollback=4000
" Disable indentlines in terminal
autocmd TermOpen * silent IndentLinesDisable
" Exit terminal mode with <esc>
tnoremap <silent><expr> <esc> (&filetype == "fzf") ? "<esc>" : "<c-\><c-n>"

" Then include the nvim specific config
lua require('config')
