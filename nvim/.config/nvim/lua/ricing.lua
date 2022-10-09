--
-- Ricing
--

local util = require('util')

local M = {}

-- Enable colored file type icons
require('nvim-web-devicons').setup {}

-- LSP status
M.lsp_status = require('lsp-status')
M.lsp_status.register_progress()

-- Setup lualine
M.lualine = require('lualine')
M.lualine.setup {
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
      -- For some reason passing the function directly doesn't work
      "require'lsp-status'.status()",
    },
  },
  extensions = {
    'fugitive',
    'fzf',
    'toggleterm',
  },
}

-- Setup bufferline
M.bufferline = require('bufferline')
M.bufferline.setup {
  options = {
    diagnostics = 'coc',
    separator_style = 'slant',
    always_show_bufferline = true,
  }
}

-- Use vim-notify as the default notification handler
M.notify = require('notify')
M.notify.setup {
  top_down = false,
}

vim.notify = M.notify.notify

-- Get nice UI elements for input and select
require('dressing').setup {}

-- Nicer symbol highlighting
require('illuminate').configure {
  providers = {
    'lsp',
    'regex',
  },
}
vim.highlight.link('IlluminatedWordText', 'LspReferenceText', true)
vim.highlight.link('IlluminatedWordRead', 'LspReferenceRead', true)
vim.highlight.link('IlluminatedWordWrite', 'LspReferenceWrite', true)

-- Setup diagnostic signs
M.sign_icons = {
  Error = '',
  Warn = '',
  Info = '',
  Hint = '~',
}

for kind, sign in pairs(M.sign_icons) do
  local hl = 'DiagnosticSign' .. kind
  vim.fn.sign_define(hl, {
    text = sign,
    texthl = hl,
    numhl = hl,
  })
end

-- Setup LSP kind symbols
M.kind_icons = {
  Class = '',          -- box
  Color = '',          -- paint palette
  Constant = '',       -- greek letter 'p' pi
  Constructor = '',    -- magic wand
  Enum = '',           -- bullet list
  EnumMember = '',     -- tag
  Event = '',          -- lightning bolt
  Field = '',          -- wrench
  File = '',           -- blank file
  Folder = '',         -- closed folder
  Function = 'λ',       -- greek letter 'l' lambda
  Interface = '',      -- power plug
  Keyword = '',        -- pound sign
  Method = '',         -- stylized 'f'
  Module =  '',        -- code file
  Operator = 'Σ',       -- greek letter 'S' sigma
  Property = '',       -- wrench
  Reference = '',      -- share arrow icon
  Snippet = '',        -- self-closing curly braces
  Struct = '',         -- tree structure
  Text = '',           -- paragraph
  TypeParameter = '',  -- greek letter 'b' beta
  Unit = '',           -- triangle ruler
  Value = '',          -- number format icon
  Variable = '',       -- greek letter 'a' alpha
}

local comp_kind = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(comp_kind) do
  comp_kind[i] = M.kind_icons[kind] or kind
end

--- Setup cmp menu styling
M.cmp_highlight_groups = {
  Pmenu =    { guifg = '#C5CDD9', guibg = '#22252A' },
  PmenuSel = { guifg = 'NONE',    guibg = '#282C34' },

  CmpItemMenu = { guifg = '#C792EA', guibg = 'NONE', gui = 'italic' },

  CmpItemAbbrDeprecated = { guifg = '#7E8294', guibg = 'NONE', gui = 'strikethrough' },
  CmpItemAbbrMatch =      { guifg = '#82AAFF', guibg = 'NONE', gui = 'bold' },
  CmpItemAbbrMatchFuzzy = { guifg = '#82AAFF', guibg = 'NONE', gui = 'bold' },

  CmpItemKindClass =         { guifg = '#EADFF0', guibg = '#A377BF' },
  CmpItemKindColor =         { guifg = '#D8EEEB', guibg = '#58B5A8' },
  CmpItemKindConstant =      { guifg = '#FFE082', guibg = '#D4BB6C' },
  CmpItemKindConstructor =   { guifg = '#FFE082', guibg = '#D4BB6C' },
  CmpItemKindEnum =          { guifg = '#C3E88D', guibg = '#9FBD73' },
  CmpItemKindEnumMember =    { guifg = '#DDE5F5', guibg = '#6C8ED4' },
  CmpItemKindEvent =         { guifg = '#EED8DA', guibg = '#B5585F' },
  CmpItemKindField =         { guifg = '#EED8DA', guibg = '#B5585F' },
  CmpItemKindFile =          { guifg = '#C5CDD9', guibg = '#7E8294' },
  CmpItemKindFolder =        { guifg = '#F5EBD9', guibg = '#D4A959' },
  CmpItemKindFunction =      { guifg = '#EADFF0', guibg = '#A377BF' },
  CmpItemKindInterface =     { guifg = '#D8EEEB', guibg = '#58B5A8' },
  CmpItemKindKeyword =       { guifg = '#C3E88D', guibg = '#9FBD73' },
  CmpItemKindMethod =        { guifg = '#DDE5F5', guibg = '#6C8ED4' },
  CmpItemKindModule =        { guifg = '#EADFF0', guibg = '#A377BF' },
  CmpItemKindOperator =      { guifg = '#EADFF0', guibg = '#A377BF' },
  CmpItemKindProperty =      { guifg = '#EED8DA', guibg = '#B5585F' },
  CmpItemKindReference =     { guifg = '#FFE082', guibg = '#D4BB6C' },
  CmpItemKindSnippet =       { guifg = '#F5EBD9', guibg = '#D4A959' },
  CmpItemKindStruct =        { guifg = '#EADFF0', guibg = '#A377BF' },
  CmpItemKindText =          { guifg = '#C3E88D', guibg = '#9FBD73' },
  CmpItemKindTypeParameter = { guifg = '#D8EEEB', guibg = '#58B5A8' },
  CmpItemKindUnit =          { guifg = '#F5EBD9', guibg = '#D4A959' },
  CmpItemKindValue =         { guifg = '#DDE5F5', guibg = '#6C8ED4' },
  CmpItemKindVariable =      { guifg = '#C5CDD9', guibg = '#7E8294' },
}
for group, info in pairs(M.cmp_highlight_groups) do
  vim.highlight.create(group, info, false)
end

local cmp_source_renames = {
  nvim_lsp = 'LSP',
  cmp_tabnine = 'T9',
}

local function cmp_format(entry, vim_item)
  -- Add some padding to the symbol
  vim_item.kind = ' ' .. (M.kind_icons[vim_item.kind] or '') .. ' '

  -- Source hint with some renames
  local source = cmp_source_renames[entry.source.name] or util.capitalize(entry.source.name)
  vim_item.menu = '     [' .. source .. ']'

  return vim_item
end

M.cmp_formatting = {
  fields = {
    'kind',
    'abbr',
    'menu',
  },
  format = cmp_format,
}

M.cmp_window = {
  completion = {
    winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
    col_offset = -3,
    side_padding = 0,
  },
}

return M
