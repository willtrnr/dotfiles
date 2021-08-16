" Force use of UTF-8 on vim
set encoding=UTF-8

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

" Adjust refresh for async stuff
set updatetime=100

" Enable mouse
set mouse=a

" Filetype stuff
filetype plugin on

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
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'lilydjwg/colorizer'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'frazrepo/vim-rainbow'
Plug 'w0rp/ale'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'tpope/vim-fugitive'
Plug 'sheerun/vim-polyglot'
Plug 'altercation/vim-colors-solarized'
Plug 'simnalamburt/vim-mundo'

if has('nvim')
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'akinsho/nvim-bufferline.lua'
  Plug 'ray-x/material_plus.nvim'
else
  Plug 'ryanoasis/vim-devicons'
  Plug 'vim-airline/vim-airline'
endif

if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

call plug#end()

"
" Ricing
"

if has('nvim')
  " Enable true-color mode
  set termguicolors

  " Use more advanced lua schemes on nvim
  let g:material_style = 'mariana'
  let g:material_style_fix = v:true
  set background=dark
  colorscheme material

  " Enable colored file type icons
  lua require('nvim-web-devicons').setup {}

  " Use Lualine and BufferLine on nvim
  lua require('lualine').setup {
  \  options = {
  \    theme = 'material'
  \  }
  \}
  lua require('bufferline').setup {
  \  options = {
  \    right_mouse_command = nil,
  \    middle_mouse_command = 'bdelete! %d',
  \    diagnostics = 'nvim_lsp',
  \    separator_style = 'slant',
  \    always_show_bufferline = true,
  \  }
  \}
else
  " Use good'ol solarized on standard vim
  colorscheme solarized
  set background=dark

  " We'll have Airline for the status line on standard vim
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
endif

"
" IndentLine
"
let g:indentLine_enabled = 0
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_concealcursor = ''

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
" ALE
"
let g:ale_disable_lsp = 1
let g:ale_linters = {
\  'python': ['mypy', 'pylint'],
\  'markdown': ['proselint'],
\}

"
" CoC
"
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
