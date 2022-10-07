--
-- Ricing
--

-- Enable colored file type icons
require('nvim-web-devicons').setup {}

-- Setup toggleterm
require('toggleterm').setup {
  open_mapping = [[<c-\>]],
}

-- Setup lualine
require('lualine').setup {
  options = {
    theme = 'nord',
  },
  sections = {
    lualine_b = {
      'branch',
      'diff',
    },
    lualine_c = {
      {
        'diagnostics',
        sources = {
          'nvim_diagnostic',
          'coc',
          'ale',
        },
        sections = {
          'error',
          'warn',
          'info',
        },
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
        },
      },
      'b:coc_current_function',
      'g:coc_status',
    },
  },
  extensions = {
    'fugitive',
    'fzf',
    'toggleterm',
  },
}

-- Setup bufferline
require('bufferline').setup {
  options = {
    diagnostics = "coc",
    separator_style = 'slant',
    always_show_bufferline = true,
  }
}

-- Setup trouble diagnostic display
require('trouble').setup {}

-- Setup diagnostic motions
require('textobj-diagnostic').setup {}

--
-- LSP
--
local key_opts = {
  noremap = true,
  silent = true,
}

-- Diagnostics navigation
vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, key_opts)
vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, key_opts)

local lsp_on_attach = function(_, bufnr)
  local buf_opts = {
    noremap = true,
    silent = true,
    buffer = bufnr,
  }

  -- Code navigation
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, buf_opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, buf_opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, buf_opts)
end

local nvim_lsp = require('lspconfig')

local lsp_flags = {
  debounce_text_change = 150,
}

nvim_lsp.pyright.setup {
  on_attach = lsp_on_attach,
  flags = lsp_flags,
}

nvim_lsp.tsserver.setup {
  on_attach = lsp_on_attach,
  flags = lsp_flags,
}

require('rust-tools').setup {
  tools = {},
  server = {
    on_attach = lsp_on_attach,
    flags = lsp_flags,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      }
    },
  },
}

--
-- Cmp
--
local cmp = require('cmp')

cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<c-space>'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'cmp_tabnine' },
  }, {
    { name = 'buffer' },
  }),
}

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})
