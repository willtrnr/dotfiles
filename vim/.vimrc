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

" Force selection of an autocomplete item, even with only one
set completeopt=menuone,noinsert,noselect

" Always show sign gutter to avoid jitter
set signcolumn=yes

" Used for hover and async stuff
set updatetime=150

" Enable mouse in normal and visual
set mouse=nv

" Disable mode display
set noshowmode

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Disable modelines execution
set nomodeline

" Change the leader to space
let mapleader=' '

" Filetype stuff
filetype plugin on

" Syntax highlight
syntax enable

" Make W and Q behave as if lowercased
:command W w
:command Wq wq
:command Wa wa
:command Q q
:command Qa qa

" Close buffer and move to previous with Ctrl-w
nnoremap <silent> <c-w> :bp<cr>:bd#<cr>

" Quick buffer switching with Tab and Shift-Tab
nnoremap <silent> <tab> :bn<cr>
nnoremap <silent> <s-tab> :bp<cr>

" Use Ctrl-kjhl to navigate windows
nnoremap <silent> <c-k> :wincmd k<cr>
nnoremap <silent> <c-j> :wincmd j<cr>
nnoremap <silent> <c-h> :wincmd h<cr>
nnoremap <silent> <c-l> :wincmd l<cr>

" Alias Alt-arrows to window navigation
nmap <silent> <a-up> <c-k>
nmap <silent> <a-down> <c-j>
nmap <silent> <a-left> <c-h>
nmap <silent> <a-right> <c-l>

" Use F9 to sort selected lines in visual or paragraph in normal
nnoremap <silent> <f9> vip:'<,'>sort<cr>
vnoremap <silent> <f9> :'<,'>sort<cr>

" Yank to system clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y

" Paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Set correct ft for Ghidra SLEIGH files
autocmd BufNewFile,BufRead *.ldefs,*.cspec,*.pspec,*.sla set filetype=xml
autocmd BufNewFile,BufRead *.slaspec,*.sinc set filetype=sleigh

"
" Load plugins
"
call plug#begin()

Plug 'arcticicestudio/nord-vim'
Plug 'dcharbon/vim-flatbuffers'
Plug 'editorconfig/editorconfig-vim'
Plug 'pest-parser/pest.vim'
Plug 'rescript-lang/vim-rescript'
Plug 'slint-ui/vim-slint'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'wakatime/vim-wakatime'
Plug 'Yggdroot/indentLine'

if has('nvim')
  " Libraries
  Plug 'nvim-lua/plenary.nvim'

  " Ricing
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v4.*' }
  Plug 'mhinz/vim-signify'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvimdev/dashboard-nvim'
  Plug 'rcarriga/nvim-notify'
  Plug 'stevearc/dressing.nvim'

  " Navigation
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
  Plug 'nvim-tree/nvim-tree.lua'

  " Completion
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-calc'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'saecki/crates.nvim'
  Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }

  " LSP & Diagnostics
  Plug 'RRethy/vim-illuminate'
  Plug 'b0o/SchemaStore.nvim'
  Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/lsp-status.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'scalameta/nvim-metals'
  Plug 'simrat39/rust-tools.nvim'
  Plug 'someone-stole-my-name/yaml-companion.nvim'
  Plug 'tamago324/nlsp-settings.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'williamboman/mason.nvim'

  " QOL
  Plug 'akinsho/toggleterm.nvim'

  " Fix CursorHold, for some reason it's not fixed for me on 800
  if v:version < 801
    Plug 'antoinemadec/FixCursorHold.nvim'
  endif
else
  let g:polyglot_disabled = [
  \  'python-compiler',
  \  'autoindent',
  \]

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'lilydjwg/colorizer'
  Plug 'mhinz/vim-signify', { 'tag': 'legacy' }
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'ryanoasis/vim-devicons'
  Plug 'sheerun/vim-polyglot'
  Plug 'vim-airline/vim-airline'
  Plug 'w0rp/ale'
endif

call plug#end()

"
" Nord theme
"
set background=dark
colorscheme nord

"
" IndentLine
"
let g:indentLine_enabled = 1
let g:indentLine_char_list = ['|', '┊', '┆', '¦']
let g:indentLine_concealcursor = 'nc'
let g:indentLine_conceallevel = '1'
let g:indentLine_bufTypeExclude = ['help', 'terminal']

if !has('nvim')
  "
  " Airline
  "
  let g:airline_theme = 'nord'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1

  "
  " ALE
  "
  let g:ale_linters = {
  \  'asm': [],
  \  'python': ['black', 'isort', 'pylint'],
  \  'rust': ['rustfmt'],
  \  'scala': [],
  \}

  let g:ale_disable_lsp = 1

  let g:ale_sign_error = ''
  let g:ale_sign_warning = ''
  let g:ale_sign_info = ''
  let g:ale_sign_hint = '~'

  let g:ale_sign_highlight_linenrs = 1

  let g:ale_python_auto_pipenv = 1
  let g:ale_python_auto_poetry = 1
  let g:ale_python_black_auto_pipenv = 1
  let g:ale_python_black_auto_poetry = 1
  let g:ale_python_isort_auto_pipenv = 1
  let g:ale_python_isort_auto_poetry = 1
  let g:ale_python_pylint_auto_pipenv = 1
  let g:ale_python_pylint_auto_poetry = 1

  "
  " FZF
  "
  let g:fzf_command_prefix = 'Fzf'

  let g:fzf_action = {
  \  'return': 'edit',
  \  'ctrl-t': 'tab split',
  \  'ctrl-x': 'split',
  \  'ctrl-v': 'vsplit',
  \}

  nnoremap <silent> <leader><tab> :FzfGFiles --cached --others --exclude-standard<cr>
  nnoremap <silent> <leader><s-tab> :FzfRg<cr>

  "
  " CoC
  "

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-@> coc#refresh()

  " Accept auto-complete with <cr>
  inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "<cr>"

  " Diagnostics navigation
  nmap <silent> [g <plug>(coc-diagnostic-prev)
  nmap <silent> ]g <plug>(coc-diagnostic-next)

  " GoTo navigation
  nmap <silent> gd <plug>(coc-definition)
  nmap <silent> gy <plug>(coc-type-definition)
  nmap <silent> gi <plug>(coc-implementation)
  nmap <silent> gr <plug>(coc-references)

  " Show code actions
  nmap <silent> <leader>A <plug>(coc-codeaction)
  nmap <silent> <leader>a <plug>(coc-codeaction-cursor)
  vmap <silent> <leader>a <plug>(coc-codeaction-selected)

  if has('nvim')
    " Show actions for codelens
    nmap <silent> <leader>l <plug>(coc-codelens-action)
  endif

  " Rename symbol
  nmap <silent> <leader>r <plug>(coc-rename)

  " Format selection
  nmap <silent> <leader>f <plug>(coc-format-selected)
  vmap <silent> <leader>f <plug>(coc-format-selected)

  " Search workspace symbols
  nnoremap <silent> <leader>s :<c-u>CocList -I symbols<cr>

  " Show documentation float
  function! s:show_documentation()
    if index(['vim', 'help'], &filetype) >= 0
      execute 'h '.expand('<cword>')
    elseif coc#rpc#ready()
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  nnoremap <silent> <leader>d :call <sid>show_documentation()<cr>

  " Handle highlight actions on cursor hold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Show signature help when jumping to param placeholders
  autocmd User CocJumpPlaceholder silent call CocActionAsync('showSignatureHelp')
endif
