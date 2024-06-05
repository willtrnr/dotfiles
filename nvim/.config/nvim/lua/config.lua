--
-- Config Entrypoint
--

local util = require('util')

-- We will need to collect LSP capabilities as we setup plugins
local lsp_caps = vim.lsp.protocol.make_client_capabilities()

-- Make a group for all our custom autocmd
local augroup = vim.api.nvim_create_augroup('aftermarket', {
   clear = true,
})

--
-- Rice our ride first
--

local ricing = require('ricing')
lsp_caps = util.update_capabilities(lsp_caps, ricing.lsp_status.capabilities)

--
-- QOL stuff
--

-- Setup toggleterm
local ok, toggleterm = pcall(require, 'toggleterm')
if ok and toggleterm then
   toggleterm.setup({
      open_mapping = [[<c-\>]],
   })
end

-- Exit terminal mode with simple <esc>
util.noremap('t', '<esc>', [[<c-\><c-n>]])

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
   group = augroup,
   callback = function()
      vim.highlight.on_yank {
         timeout = 500,
         on_visual = false,
      }
   end,
})

--
-- Navigation
--

-- Telescope finders and menus
local telescope = require('telescope')
local telescope_config = require('telescope.config')
local telescope_actions = require('telescope.actions')
telescope.setup {
   defaults = {
      mappings = {
         i = {
            -- Directly close on <esc> instead of going to normal
            ['<esc>'] = telescope_actions.close,
         },
      },
      vimgrep_arguments = util.list_concat(
      -- Include dotfiles in search
         telescope_config.values.vimgrep_arguments, {
            '--hidden',
            '--glob', '!.git/*',
         }
      ),
   },
   pickers = {
      find_files = {
         find_command = {
            'rg',
            '--files',
            '--color', 'never',
            -- We need to manually inject this with hidden=true
            '--glob', '!.git/*',
         },
         hidden = true,
      },
   },
   extensions = {
      lsp_handlers = {
         disable = {
            -- Broken in recent versions, handled by Dressing instead
            ['textDocument/codeAction'] = true,
         },
      },
   },
}
telescope.load_extension('fzf')
telescope.load_extension('lsp_handlers')
telescope.load_extension('notify')

local telescope_builtin = require('telescope.builtin')
util.noremap('n', '<leader><tab>', telescope_builtin.find_files)
util.noremap('n', '<leader><s-tab>', telescope_builtin.live_grep)

local tree = require("nvim-tree")
tree.setup({
   view = {
      width = 35,
   },
   actions = {
      open_file = {
         window_picker = {
            enable = false,
         },
      },
   },
   filters = {
      custom = {
         '^.git$',
      },
   },
})

local tree_api = require("nvim-tree.api").tree;
util.noremap('n', '<leader>t', tree_api.open)

--
-- Completion
--

-- Setup crates.io version completion and annotations
require('crates').setup()

-- Setup cmp for completion
local cmp = require('cmp')
cmp.setup({
   formatting = ricing.cmp_formatting,
   mapping = cmp.mapping.preset.insert({
      -- Call up the autocomplete on <ctrl-space>
      ['<c-space>'] = cmp.mapping.complete(),
      -- Accept the explicitly selected option
      ['<cr>'] = cmp.mapping.confirm({ select = false }),
      -- Accept the first or selected option
      ['<tab>'] = cmp.mapping.confirm({ select = true }),
   }),
   snippet = {
      expand = function(args)
         vim.fn['vsnip#anonymous'](args.body)
      end,
   },
   sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'calc' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'cmp_tabnine' },
      { name = 'crates' },
   }),
   window = ricing.cmp_window,
})

-- Extend the LSP caps with the cmp caps
local cmp_lsp = require('cmp_nvim_lsp')
lsp_caps = util.update_capabilities(lsp_caps, cmp_lsp.default_capabilities())

--
-- LSP & Diagnostics
--

require('nvim-treesitter.configs').setup({
   highlight = {
      enable = true,
   },
   incremental_selection = {
      enable = true,
   },
   textobjects = {
      enable = true,
   },
})

-- Mason package manager for LSP servers and linters
require('mason').setup()

-- Diagnostics navigation
util.noremap('n', 'g[', vim.diagnostic.goto_prev)
util.noremap('n', 'g]', vim.diagnostic.goto_next)

-- Show diagnostic at cursor position in a floating window
vim.api.nvim_create_autocmd('CursorHold', {
   group = augroup,
   callback = function()
      vim.diagnostic.open_float(nil, {
         focusable = false,
         close_events = {
            'BufLeave',
            'CursorMoved',
            'InsertEnter',
         },
         scope = 'cursor',
         source = 'if_many',
      })
   end
})

-- LSP server auto-configuration
local lspconfig = require('lspconfig')

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup()

-- Code actions indicator
local lightbulb = require('nvim-lightbulb')
lightbulb.setup({
   sign = {
      text = ricing.lightbulb_icon,
   },
})

local function lsp_notify_unsupported(feature)
   local msg = 'Unsuppported ' .. util.capitalize(feature)
   return function()
      vim.notify(msg, 'info')
   end
end

local function lsp_on_attach(client, bufnr)
   local caps = client.server_capabilities

   local function lsp_nmap(feature, key, action)
      if caps[feature] then
         util.noremap('n', key, action, bufnr)
      else
         util.noremap('n', key, lsp_notify_unsupported(feature), bufnr, true)
      end
   end

   -- Attach the client to lsp-status
   ricing.lsp_status.on_attach(client)

   -- Show symbol documentation
   lsp_nmap('hoverProvider', '<leader>d', vim.lsp.buf.hover)

   -- Show signature help
   lsp_nmap('signatureHelpProvider', '<c-s>', vim.lsp.buf.signature_help)

   -- Code navigation
   lsp_nmap('definitionProvider', 'gd', vim.lsp.buf.definition)
   lsp_nmap('typeDefinitionProvider', 'gy', vim.lsp.buf.type_definition)
   lsp_nmap('implementationProvider', 'gi', vim.lsp.buf.implementation)
   lsp_nmap('referencesProvider', 'gr', vim.lsp.buf.references)

   -- Rename symbol
   lsp_nmap('renameProvider', '<leader>r', vim.lsp.buf.rename)

   -- Format
   lsp_nmap('documentFormattingProvider', '<leader>f', vim.lsp.buf.format or vim.lsp.buf.formatting)

   -- Code actions
   lsp_nmap('codeActionProvider', '<leader>a', vim.lsp.buf.code_action)
   if caps.codeActionProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
         group = augroup,
         buffer = bufnr,
         callback = util.thunkify(lightbulb.update_lightbulb),
      })
   end

   -- Code lens
   lsp_nmap('codeLensProvider', '<leader>l', vim.lsp.codelens.run)
   if caps.codeLensProvider then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
         group = augroup,
         buffer = bufnr,
         callback = util.thunkify(vim.lsp.codelens.refresh),
      })
   end
end

mason_lspconfig.setup_handlers({
   function(server_name)
      lspconfig[server_name].setup({
         capabilities = lsp_caps,
         on_attach = lsp_on_attach,
      })
   end,
   ['rust_analyzer'] = function()
      require('rust-tools').setup({
         tools = {
            runnables = {
               use_telescope = true
            },
         },
         server = {
            capabilities = lsp_caps,
            on_attach = lsp_on_attach,
            settings = {
               ['rust-analyzer'] = {
                  cargo = {
                     buildScripts = {
                        enable = true,
                     },
                  },
                  imports = {
                     group = {
                        enable = false,
                     },
                  },
                  procMacro = {
                     enable = true,
                  },
               },
            },
         },
      })
   end
})

local metals = require('metals')
local metals_lsp_status = require('metals_lsp_status')

vim.api.nvim_create_autocmd('FileType', {
   group = vim.api.nvim_create_augroup('nvim-metals', {
      clear = true,
   }),
   pattern = {
      'sbt',
      'scala',
   },
   callback = function()
      metals.initialize_or_attach({
         capabilities = lsp_caps,
         handlers = metals_lsp_status.setup(),
         init_options = {
            compilerOptions = {},
            statusBarProvider = 'on',
         },
         on_attach = lsp_on_attach,
         settings = {
            showImplicitArguments = true,
         },
         tvp = {},
      })
   end,
})

-- Allow overriding LSP settings locally, use vim dir for .gitignore compat
require('nlspsettings').setup({
   local_settings_dir = '.vim',
})
