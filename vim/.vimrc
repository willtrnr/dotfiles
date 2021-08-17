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

" Enable mouse in normal and visual
set mouse=nv

" Disable mode display
set noshowmode

" More space for diagnostic messages in the command bar
set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Change the leader to space
let mapleader=' '

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
nnoremap <silent> <tab> :bn<cr>
nnoremap <silent> <s-tab> :bp<cr>

if has('nvim')
  " Exit terminal mod with <esc>
  tnoremap <esc> <c-\><c-n>
endif

"
" Polyglot
"
" This needs to happen before the plugin is loaded
let g:polyglot_disabled = ['python-compiler', 'autoindent']

"
" Load plugins
"
call plug#begin()

Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'frazrepo/vim-rainbow'
Plug 'lilydjwg/colorizer'
Plug 'majutsushi/tagbar', { 'on': ['TagbarOpen', 'TagbarToggle', 'TagbarOpenAutoClose'] }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'preservim/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeOpen', 'NERDTreeToggle', 'NERDTreeFocus'] }
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeOpen', 'NERDTreeToggle', 'NERDTreeFocus'] }
Plug 'Yggdroot/indentLine'

if has('nvim')
  Plug 'akinsho/nvim-bufferline.lua'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'ray-x/material_plus.nvim'
else
  Plug 'altercation/vim-colors-solarized'
  Plug 'ryanoasis/vim-devicons'
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

let g:airline_powerline_fonts = 1

if has('nvim')
  " Enable true-color mode
  set termguicolors

  " Use the mariana material theme
  let g:material_style = 'mariana'
  let g:material_style_fix = v:true
  set background=dark
  colorscheme material

  " Pick an appropriate Airline theme for the color scheme
  let g:airline_theme = 'deus'

  " Enable colored file type icons
  lua require('nvim-web-devicons').setup {}

  " Make sure the Airline tabline is disabled to make room for bufferline
  let g:airline#extensions#tabline#enabled = 0

  " Setup buffline
  lua require('bufferline').setup {
  \  options = {
  \    right_mouse_command = nil,
  \    middle_mouse_command = 'bdelete! %d',
  \    separator_style = 'slant',
  \    always_show_bufferline = true,
  \  }
  \}
else
  " Use good'ol solarized on standard vim
  set background=dark
  colorscheme solarized

  " Pick an appropriate Airline theme for the color scheme
  let g:airline_theme = 'solarized'
  let g:airline_solarized_bg = 'dark'

  " Use the Airline provided tabline
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
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Diagnostics navigation
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show code actions for selection
nmap <silent> <leader>a <Plug>(coc-codeaction-cursor)
vmap <silent> <leader>a <Plug>(coc-codeaction-selected)

" Show documentation window
nnoremap <silent> <leader>d :call <sid>show_documentation()<cr>

function! s:show_documentation()
  if index(['vim','help'], &filetype) >= 0
    execute 'h '.expand('<cword>')
  elseif coc#rpc#ready()
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Format selection
nmap <silent> <leader>f <Plug>(coc-format-selected)
vmap <silent> <leader>f <Plug>(coc-format-selected)

" Highlight symbol references on hold
autocmd CursorHold * silent call CocActionAsync('highlight')

"
" NERDTree
"
let g:NERDTreeQuitOnOpen = 3
let g:NERDTreeMinimalUI = 1

nnoremap <silent> <leader>e :NERDTreeFocus<cr>
nnoremap <silent> <c-e> :NERDTreeToggle<cr>

"
" Tagbar
"
nnoremap <silent> <leader>t :TagbarOpenAutoClose<cr>
nnoremap <silent> <c-t> :TagbarToggle<cr>
