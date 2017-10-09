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

" Filetype stuff
:filetype plugin on

" Make Wq and W behave
:command W w
:command Wq wq
:command Q q

" Airline config
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" CtrlP config
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
