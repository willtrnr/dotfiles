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
Plug 'ionide/Ionide-vim'
Plug 'rescript-lang/vim-rescript'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'wakatime/vim-wakatime'

if has('nvim')
  " Libraries
  Plug 'nvim-lua/plenary.nvim'

  " Ricing
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v4.*' }
  Plug 'catgoose/nvim-colorizer.lua'
  Plug 'folke/snacks.nvim'
  Plug 'j-hui/fidget.nvim', { 'tag': 'v1.*' }
  Plug 'mcauley-penney/visual-whitespace.nvim'
  Plug 'mhinz/vim-signify'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'sphamba/smear-cursor.nvim'

  " Navigation
  Plug 'dmtrKovalenko/fff.nvim'

  " Completion
  Plug 'codota/tabnine-nvim', { 'commit': '6d209e52239e09e19c4913595cb253d2c364afa8', 'do': './dl_binaries.sh' }
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
  Plug 'kosayoda/nvim-lightbulb'
  Plug 'lopi-py/luau-lsp.nvim'
  if has('nvim-0.11.3')
    Plug 'mason-org/mason-lspconfig.nvim', { 'tag': 'v2.*' }
    Plug 'mason-org/mason.nvim', { 'tag': 'v2.*' }
    Plug 'mrcjkb/rustaceanvim', { 'tag': 'v6.*' }
  else
    Plug 'mason-org/mason.nvim', { 'tag': 'v1.*' }
    Plug 'mason-org/mason-lspconfig.nvim', { 'tag': 'v1.*' }
    Plug 'mrcjkb/rustaceanvim', { 'tag': 'v5.*' }
  endif
  Plug 'mfussenegger/nvim-dap'
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'neovim/nvim-lspconfig'
  if has('nvim-0.12')
    Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main', 'do': ':TSUpdate' }
  else
    Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'master', 'do': ':TSUpdate' }
  endif
  Plug 'scalameta/nvim-metals'
  Plug 'someone-stole-my-name/yaml-companion.nvim'
  Plug 'theHamsta/nvim-dap-virtual-text'
endif

call plug#end()

" We only use Ionide for syntax
let g:fsharp#backend="disable"
let g:fsharp#fsi_keymap = "none"
let g:fsharp#lsp_auto_setup=0

"
" Nord theme
"
set background=dark
colorscheme nord
