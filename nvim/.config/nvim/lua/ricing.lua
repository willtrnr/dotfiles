--
-- Ricing
--

local util = require('util')

local M = {}

-- Enable colored file type icons
require('nvim-web-devicons').setup()

-- Color values highlight
require('colorizer').setup()

-- LSP status
M.lsp_status = require('lsp-status')
M.lsp_status.register_progress()

-- Setup lualine
local function lualine_fmt_mode(v)
   if v == "COMMAND" then
      return "CMD"
   else
      return string.sub(v, 1, 1) .. string.gsub(string.sub(v, 2), "[AEIOU]", "")
   end
end

local function lualine_lsp_status()
   local success, res = pcall(M.lsp_status.status)
   if success then
      return string.gsub(res, "%%", "%%%%")
   end
end

M.lualine = require('lualine')
M.lualine.setup({
   options = {
      theme = 'nord',
   },
   sections = {
      lualine_a = {
         { 'mode', fmt = lualine_fmt_mode },
      },
      lualine_b = {
         'branch',
         'diff',
      },
      lualine_c = {
         {
            'diagnostics',
            sources = {
               'nvim_diagnostic',
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
         lualine_lsp_status,
      },
   },
   extensions = {
      'fugitive',
      'fzf',
      'mason',
      'toggleterm',
   },
})

-- Setup bufferline
M.bufferline = require('bufferline')
M.bufferline.setup({
   options = {
      diagnostics = 'nvim_lsp',
      separator_style = 'slant',
      always_show_bufferline = true,
   }
})

-- Use vim-notify as the default notification handler
M.notify = require('notify')
M.notify.setup({
   top_down = false,
})

vim.notify = M.notify.notify

-- Get nice UI elements for input and select
local ok, dressing = pcall(require, 'dressing')
if ok and dressing then
   dressing.setup({
      input = {
         win_options = {
            winblend = 0,
         },
      },
      select = {
         nui = {
            win_options = {
               winblend = 0,
            },
         },
         builtin = {
            win_options = {
               winblend = 0,
            },
         },
      },
   })
end

-- Nicer symbol highlighting
require('illuminate').configure({
   providers = {
      'lsp',
      'treesitter',
      'regex',
   },
})

vim.api.nvim_set_hl(0, 'IlluminatedWordText', {
   link = 'LspReferenceText',
   default = true,
})
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', {
   link = 'LspReferenceRead',
   default = true,
})
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', {
   link = 'LspReferenceWrite',
   default = true,
})

-- Setup diagnostic signs
M.sign_icons = {
   Error = '',
   Warn = '',
   Info = '',
   Hint = '󰟶',
}

for kind, sign in pairs(M.sign_icons) do
   local hl = 'DiagnosticSign' .. kind
   vim.fn.sign_define(hl, {
      text = sign,
      texthl = hl,
      numhl = hl,
   })
end

-- Extra lightbulb diagnostic
M.lightbulb_icon = '󱠃'

-- Setup LSP kind symbols
M.kind_icons = {
   Class = '', -- box
   Color = '', -- paint palette
   Constant = 'π', -- greek letter 'p' pi
   Constructor = '', -- magic wand
   Enum = '', -- bullet list
   EnumMember = '', -- tag
   Event = '', -- lightning bolt
   Field = '', -- wrench
   File = '󰈤', -- blank file
   Folder = '', -- closed folder
   Function = 'λ', -- greek letter 'l' lambda
   Interface = '', -- power plug
   Keyword = '', -- pound sign
   Method = '󰊕', -- stylized 'f'
   Module = '', -- code file
   Operator = 'Σ', -- greek letter 'S' sigma
   Property = '', -- wrench
   Reference = '', -- share arrow icon
   Snippet = '', -- self-closing curly braces
   Struct = '', -- tree structure
   Text = '', -- paragraph
   TypeParameter = 'β', -- greek letter 'b' beta
   Unit = '', -- triangle ruler
   Value = '󰎠', -- number format icon
   Variable = 'α', -- greek letter 'a' alpha
}

local comp_kind = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(comp_kind) do
   comp_kind[i] = M.kind_icons[kind] or kind
end

--- Setup cmp menu styling
M.cmp_highlight_groups = {
   Pmenu = { fg = '#C5CDD9', bg = '#22252A' },
   PmenuSel = { fg = 'NONE', bg = '#282C34' },

   CmpItemMenu = { fg = '#C792EA', bg = 'NONE', italic = true },

   CmpItemAbbrDeprecated = { fg = '#7E8294', bg = 'NONE', strikethrough = true },
   CmpItemAbbrMatch = { fg = '#82AAFF', bg = 'NONE', bold = true },
   CmpItemAbbrMatchFuzzy = { fg = '#82AAFF', bg = 'NONE', bold = true },

   CmpItemKindClass = { fg = '#EADFF0', bg = '#A377BF' },
   CmpItemKindColor = { fg = '#D8EEEB', bg = '#58B5A8' },
   CmpItemKindConstant = { fg = '#FFE082', bg = '#D4BB6C' },
   CmpItemKindConstructor = { fg = '#FFE082', bg = '#D4BB6C' },
   CmpItemKindEnum = { fg = '#C3E88D', bg = '#9FBD73' },
   CmpItemKindEnumMember = { fg = '#DDE5F5', bg = '#6C8ED4' },
   CmpItemKindEvent = { fg = '#EED8DA', bg = '#B5585F' },
   CmpItemKindField = { fg = '#EED8DA', bg = '#B5585F' },
   CmpItemKindFile = { fg = '#C5CDD9', bg = '#7E8294' },
   CmpItemKindFolder = { fg = '#F5EBD9', bg = '#D4A959' },
   CmpItemKindFunction = { fg = '#EADFF0', bg = '#A377BF' },
   CmpItemKindInterface = { fg = '#D8EEEB', bg = '#58B5A8' },
   CmpItemKindKeyword = { fg = '#C3E88D', bg = '#9FBD73' },
   CmpItemKindMethod = { fg = '#DDE5F5', bg = '#6C8ED4' },
   CmpItemKindModule = { fg = '#EADFF0', bg = '#A377BF' },
   CmpItemKindOperator = { fg = '#EADFF0', bg = '#A377BF' },
   CmpItemKindProperty = { fg = '#EED8DA', bg = '#B5585F' },
   CmpItemKindReference = { fg = '#FFE082', bg = '#D4BB6C' },
   CmpItemKindSnippet = { fg = '#F5EBD9', bg = '#D4A959' },
   CmpItemKindStruct = { fg = '#EADFF0', bg = '#A377BF' },
   CmpItemKindText = { fg = '#C3E88D', bg = '#9FBD73' },
   CmpItemKindTypeParameter = { fg = '#D8EEEB', bg = '#58B5A8' },
   CmpItemKindUnit = { fg = '#F5EBD9', bg = '#D4A959' },
   CmpItemKindValue = { fg = '#DDE5F5', bg = '#6C8ED4' },
   CmpItemKindVariable = { fg = '#C5CDD9', bg = '#7E8294' },
}

for group, info in pairs(M.cmp_highlight_groups) do
   vim.api.nvim_set_hl(0, group, info)
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
