execute pathogen#infect()

" Filetype stuff
filetype plugin on

" Line highlight
set cursorline

" Relative and current line numbers
set relativenumber
set number

" Allow switching out of an unsaved buffer
set hidden

" Fix some file watching stuff for webpack
set backupcopy=yes

" Search casing
set ignorecase
set smartcase

" Better tab complete
set wildmode=longest,list,full
set wildmenu

" Always show sign gutter to avoid jitter
set signcolumn=yes

" Solarized
syntax enable
colorscheme solarized
set background=dark

" Make Wq, W and Q behave as if lowercased
:command W w
:command Wq wq
:command Q q

" Conveniant aliases
:map :wbd :w<cr>:bd<cr>

" Plugin stuff

" Airline
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" JSX
let g:jsx_ext_required = 0

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint', 'flow']
let g:syntastic_javascript_eslint_exe = '/usr/bin/eslint_d'
let g:syntastic_javascript_flow_exe = '/usr/bin/yarn run --silent 2>/dev/null flow'

let g:syntastic_java_checkers = ['checkstyle']
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_java_checkstyle_classpath = '/usr/share/java/checkstyle/checkstyle.jar'
let g:syntastic_java_checkstyle_conf_file = 'checkstyle.xml'

" CoC
set updatetime=300
set shortmess+=c

" Use Ctrl-Space for completion
inoremap <silent><expr> <c-space> coc#refresh()
