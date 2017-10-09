execute pathogen#infect()

" Solarized
syntax enable
colorscheme solarized
set background=dark

" Line highlight
set cursorline

" Relative and current line numbers
set relativenumber
set number

" Allow switching out of an unsaved buffer
set hidden

" Make Wq and W behave
:command W w
:command Wq wq

" Airline config
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
