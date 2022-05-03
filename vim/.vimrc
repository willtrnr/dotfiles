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
"set cmdheight=2

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

" Make Wq, W and Q behave as if lowercased
:command W w
:command Wq wq
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

" Use leader-s to sort selected lines
vnoremap <silent> <leader>s :'<,'>sort<cr>

if has('nvim')
  " Set terminal scrollback much lower to avoid lag issues
  set scrollback=4000
  " Exit terminal mode with <esc>
  tnoremap <expr> <esc> (&filetype == "fzf") ? "<esc>" : "<c-\><c-n>"
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

Plug 'arcticicestudio/nord-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lilydjwg/colorizer'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'preservim/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'w0rp/ale'
Plug 'wakatime/vim-wakatime'
Plug 'Yggdroot/indentLine'

if has('nvim')
  Plug 'akinsho/nvim-bufferline.lua'
  Plug 'akinsho/toggleterm.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'nvim-lualine/lualine.nvim'
else
  Plug 'vim-airline/vim-airline'
  Plug 'ryanoasis/vim-devicons'
endif

call plug#end()

"
" Ricing
"

" Use Nord theme
set background=dark
colorscheme nord

if has('nvim')
  " Enable true-color mode
  set termguicolors

  " Enable colored file type icons
  lua require('nvim-web-devicons').setup {}

  " Setup toggleterm
  lua require('toggleterm').setup {
  \  open_mapping = [[<c-\>]],
  \}

  " Setup lualine
  lua require('lualine').setup {
  \  options = {
  \    theme = 'nord',
  \  },
  \  sections = {
  \    lualine_b = {
  \      'branch',
  \      'diff',
  \    },
  \    lualine_c = {
  \      {
  \        'diagnostics',
  \        sources = { 'nvim_diagnostic', 'coc', 'ale' },
  \        sections = { 'error', 'warn', 'info' },
  \        symbols = { error = ' ', warn = ' ', info = ' ' },
  \      },
  \      'g:coc_status',
  \      'b:coc_current_function',
  \    },
  \  },
  \  extensions = {
  \    'fugitive',
  \    'fzf',
  \    'toggleterm',
  \  },
  \}

  " Setup bufferline
  lua require('bufferline').setup {
  \  options = {
  \    right_mouse_command = nil,
  \    middle_mouse_command = 'bdelete! %d',
  \    separator_style = 'slant',
  \    always_show_bufferline = true,
  \  }
  \}
else
  let g:airline_theme = 'nord'
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

if has('nvim')
  autocmd TermOpen * silent IndentLinesDisable
endif

"
" ALE
"
let g:ale_disable_lsp = 1
let g:ale_linters = {
\  'python': ['pylint'],
\  'markdown': ['proselint'],
\}

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
" Until I get used to leader-tab
nmap <silent> <c-p> <leader><tab>

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
nmap <silent> [g <plug>(coc-diagnostic-prev)
nmap <silent> ]g <plug>(coc-diagnostic-next)

" GoTo navigation
nmap <silent> gd <plug>(coc-definition)
nmap <silent> gy <plug>(coc-type-definition)
nmap <silent> gi <plug>(coc-implementation)
nmap <silent> gr <plug>(coc-references)

" Show code actions
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
