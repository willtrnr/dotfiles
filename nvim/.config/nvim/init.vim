" Use the standard vim paths
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Delegate to the common vimrc file
source ~/.vimrc
