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
nnoremap <silent> <C-w> :bp<CR>:bd#<CR>

" Quick buffer switching with Tab and Shift-Tab
nnoremap <silent> <Tab> :bn<CR>
nnoremap <silent> <S-Tab> :bp<CR>

" Use Ctrl-kjhl to navigate windows
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

" Alias Alt-arrows to window navigation
nmap <silent> <A-Up> <C-k>
nmap <silent> <A-Down> <C-j>
nmap <silent> <A-Left> <C-h>
nmap <silent> <A-Right> <C-l>

" Use F9 to sort selected lines in visual or paragraph in normal
nnoremap <silent> <F9> vip:'<,'>sort<CR>
vnoremap <silent> <F9> :'<,'>sort<CR>

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
Plug 'rescript-lang/vim-rescript'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'wakatime/vim-wakatime'

if has('nvim')
  " Libraries
  Plug 'nvim-lua/plenary.nvim'

  " Ricing
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v4.*' }
  Plug 'folke/snacks.nvim'
  Plug 'j-hui/fidget.nvim', { 'tag': 'v1.*' }
  Plug 'mcauley-penney/visual-whitespace.nvim'
  Plug 'mhinz/vim-signify'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-tree/nvim-web-devicons'

  " Navigation
  Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

  " Completion
  Plug 'codota/tabnine-nvim', { 'do': './dl_binaries.sh' }
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-calc'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'onsails/lspkind.nvim'
  Plug 'saecki/crates.nvim'

  " LSP & Diagnostics
  Plug 'RRethy/vim-illuminate'
  Plug 'b0o/SchemaStore.nvim'
  Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'lopi-py/luau-lsp.nvim'
  if has('nvim-0.11')
    Plug 'mason-org/mason.nvim', { 'tag': 'v2.*' }
    Plug 'mason-org/mason-lspconfig.nvim', { 'tag': 'v2.*' }
    Plug 'mrcjkb/rustaceanvim', { 'tag': 'v6.*' }
  else
    Plug 'mason-org/mason.nvim', { 'tag': 'v1.*' }
    Plug 'mason-org/mason-lspconfig.nvim', { 'tag': 'v1.*' }
    Plug 'mrcjkb/rustaceanvim', { 'tag': 'v5.*' }
  endif
  Plug 'mfussenegger/nvim-dap'
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/lsp-status.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'scalameta/nvim-metals'
  Plug 'someone-stole-my-name/yaml-companion.nvim'
  Plug 'theHamsta/nvim-dap-virtual-text'
endif

call plug#end()

"
" Nord theme
"
set background=dark
colorscheme nord
