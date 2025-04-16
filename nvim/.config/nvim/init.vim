" Use the standard vim paths
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Enable true-color mode
set termguicolors

" Include the common vimrc file first
source ~/.vimrc

" Set terminal scrollback much lower to avoid lag
set scrollback=4000

" Chainload the nvim specific Lua config
lua require('config.init')
