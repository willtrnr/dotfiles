" Filetype stuff
filetype plugin on

" Line highlight
set cursorline

" Relative and current line numbers
set relativenumber
set number

" Allow switching out of an unsaved buffer
set hidden

" Fix some file watching stuff
set nobackup
set nowritebackup

" Search casing
set ignorecase
set smartcase

" Better tab complete
set wildmode=longest,list,full
set wildmenu

" Always show sign gutter to avoid jitter
set signcolumn=yes

" Syntax highlight
syntax enable

" Make Wq, W and Q behave as if lowercased
:command W w
:command Wq wq
:command Q q
:command Qa qa

" Write buffer and close
:map :wbd :w<cr>:bd<cr>

" Quick buffer switching with Tab and Shift-Tab
nnoremap <silent> <tab> :bn<CR>
nnoremap <silent> <s-tab> :bp<CR>

"
" Polyglot
"
" This needs to happen before the plugin is loaded
let g:polyglot_disabled = ['python-compiler', 'autoindent']

"
" Load plugins
"
execute pathogen#infect()

"
" Solarized
"
colorscheme solarized
set background=dark

"
" Airline
"
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

"
" IndentLine
"

let g:indentLine_enabled = 0
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_concealcursor = ''

"
" Minimap
"
let g:minimap_highlight = 'Constant'

"
" CtrlP
"
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"
" Syntastic
"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_java_checkers = ['checkstyle']
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_java_checkstyle_classpath = '/usr/share/java/checkstyle/checkstyle.jar'
let g:syntastic_java_checkstyle_conf_file = 'checkstyle.xml'

let g:syntastic_cs_checkers = ['code_checker']

let g:syntastic_markdown_checkers = ['proselint']

let g:syntastic_python_checkers = ['mypy', 'pylint']

"
" CoC
"
set updatetime=300
set shortmess+=c

" Navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight symbol references on hold
autocmd CursorHold * silent call CocActionAsync('highlight')

"
" OmniSharp
"
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_selector_ui = 'ctrlp'
let g:OmniSharp_highlight_types = 2

augroup omnisharp_commands
  autocmd!
  autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
  autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
augroup END
