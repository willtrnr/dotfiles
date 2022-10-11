local util = require('util')

--
-- Rice our ride first
--

local ricing = require('ricing')

-- Initialize the LSP caps map with lsp-status from the ricing
local lsp_caps = ricing.lsp_status.capabilities

-- Make a group for all our custom autocmd
local augroup = vim.api.nvim_create_augroup('aftermarket', {
  clear = true,
})

--
-- QOL stuff
--

-- Setup toggleterm
require('toggleterm').setup {
  open_mapping = [[<c-\>]],
}

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
-- Completion & Finders
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

local telescope_builtin = require('telescope.builtin')
util.noremap('n', '<leader><tab>', telescope_builtin.find_files)
util.noremap('n', '<leader><s-tab>', telescope_builtin.live_grep)

-- Setup crates.io version completion and annotations
require('crates').setup {}

-- Setup cmp for completion
local cmp = require('cmp')

cmp.setup {
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
}

-- Extend the LSP caps with the cmp caps
lsp_caps = require('cmp_nvim_lsp').update_capabilities(lsp_caps)

--
-- LSP & Diagnostics
--

-- Mason package manager for LSP servers and linters
require('mason').setup {}

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
mason_lspconfig.setup {}

-- Code actions indicator
local lightbulb = require('nvim-lightbulb')
lightbulb.setup {}

local lsp_on_attach = function(client, bufnr)
  local caps = client.server_capabilities

  -- Attach the client to lsp-status
  ricing.lsp_status.on_attach(client)

  -- Show symbol documentation
  if caps.hoverProvider then
    util.noremap('n', '<leader>d', vim.lsp.buf.hover, bufnr)
  end

  -- Show signature help
  if caps.signatureHelpProvider then
    util.noremap('n', '<c-s>', vim.lsp.buf.signature_help, bufnr)
  end

  -- Code navigation
  if caps.definitionProvider then
    util.noremap('n', 'gd', vim.lsp.buf.definition, bufnr)
  end
  if caps.typeDefinitionProvider then
    util.noremap('n', 'gy', vim.lsp.buf.type_definition, bufnr)
  end
  if caps.implementationProvider then
    util.noremap('n', 'gi', vim.lsp.buf.implementation, bufnr)
  end
  if caps.referencesProvider then
    util.noremap('n', 'gr', vim.lsp.buf.references, bufnr)
  end

  -- Code actions
  if caps.codeActionProvider then
    util.noremap('n', '<leader>a', vim.lsp.buf.code_action, bufnr)

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = augroup,
      buffer = bufnr,
      callback = util.thunkify(lightbulb.update_lightbulb),
    })
  end

  -- Rename symbol
  if caps.renameProvider then
    util.noremap('n', '<leader>r', vim.lsp.buf.rename, bufnr)
  end

  -- Format
  if caps.documentFormattingProvider or caps.documentRangeFormattingProvider then
    util.noremap('n', '<leader>f', vim.lsp.buf.format or vim.lsp.buf.formatting, bufnr)
  end
end

mason_lspconfig.setup_handlers {
  function (server_name)
    lspconfig[server_name].setup {
      capabilities = lsp_caps,
      on_attach = lsp_on_attach,
    }
  end,
  ['rust_analyzer'] = function ()
    require('rust-tools').setup {
      tools = {},
      server = {
        capabilities = lsp_caps,
        on_attach = lsp_on_attach,
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = 'clippy',
            },
          }
        },
      },
    }
  end
}

local metals = require('metals')
local metals_lsp_status = require('metals_lsp_status')

local metals_opts = {
  capabilities = lsp_caps,
  handlers = metals_lsp_status.setup(),
  init_options = {
    compilerOptions = {},
    statusBarProvider = 'on',
  },
  on_attach = lsp_on_attach,
  settings = {
    disabledMode = true,
    showImplicitArguments = true,
  },
  tvp = {},
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('nvim-metals', {
    clear = true,
  }),
  pattern = {
    'java',
    'sbt',
    'scala',
  },
  callback = function()
    metals.initialize_or_attach(metals_opts)
  end,
})

-- Allow overriding LSP settings locally, use vim dir for .gitignore compat
require('nlspsettings').setup {
  local_settings_dir = '.vim',
}
