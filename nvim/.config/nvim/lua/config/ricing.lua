--
-- Ricing
--

local M = {}

-- Enable colored file type icons
require("nvim-web-devicons").setup()

-- Color values highlight
require("colorizer").setup()

-- Render whitespaces
require("visual-whitespace").setup({})

-- LSP status
M.lsp_status = require("lsp-status")

M.fidget = require("fidget")
M.fidget.setup({
   notification = {
      override_vim_notify = true,
   },
})

-- Setup lualine
local function lualine_fmt_mode(v)
   if v == "COMMAND" then
      return "CMD"
   elseif v == "TERMINAL" then
      return "TERM"
   else
      return string.gsub(v, "[AEIOU]", "")
   end
end

local function lualine_lsp_status()
   local success, status = pcall(M.lsp_status.status)
   if success and status then
      return status
   else
      return ""
   end
end

local yaml_companion = require("yaml-companion")

local function lualine_yaml_schema()
   local success, name = pcall(function()
      return yaml_companion.get_buf_schema(0).result[1].name
   end)

   if success and name ~= "none" then
      return name
   else
      return ""
   end
end

local tabnine_status = require("tabnine.status")

local function lualine_tabnine_status()
   local status = tabnine_status.status()
   return string.gsub(status, " tabnine", "")
end

M.lualine = require("lualine")
M.lualine.setup({
   options = {
      theme = "nord",
   },
   sections = {
      lualine_a = {
         { "mode", fmt = lualine_fmt_mode },
      },
      lualine_b = {
         "branch",
         "diff",
      },
      lualine_c = {
         {
            "diagnostics",
            sources = {
               "nvim_diagnostic",
            },
            sections = {
               "error",
               "warn",
               "info",
            },
            symbols = {
               error = " ",
               warn = " ",
               info = " ",
            },
         },
         "filename",
         lualine_lsp_status,
      },
      lualine_x = {
         "encoding",
         "fileformat",
         "filetype",
         lualine_yaml_schema,
         lualine_tabnine_status,
      },
   },
   extensions = {
      "fugitive",
      "fzf",
      "mason",
   },
})

-- Setup bufferline
M.bufferline = require("bufferline")
M.bufferline.setup({
   options = {
      diagnostics = "nvim_lsp",
      separator_style = "slant",
      always_show_bufferline = true,
   },
})

-- Nicer symbol highlighting
require("illuminate").configure({
   providers = {
      "lsp",
      "treesitter",
      "regex",
   },
})

vim.api.nvim_set_hl(0, "IlluminatedWordText", {
   link = "LspReferenceText",
   default = true,
})
vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
   link = "LspReferenceRead",
   default = true,
})
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
   link = "LspReferenceWrite",
   default = true,
})

-- Setup diagnostic signs
M.sign_icons = {
   Error = "",
   Warn = "",
   Info = "",
   Hint = "󰟶",
}

for kind, sign in pairs(M.sign_icons) do
   local hl = "DiagnosticSign" .. kind
   vim.fn.sign_define(hl, {
      text = sign,
      texthl = hl,
      numhl = hl,
   })
end

-- Extra lightbulb diagnostic
M.lightbulb_icon = "󱠃"

-- Setup cmp menu styling
M.cmp_highlight_groups = {
   Pmenu = { fg = "#C5CDD9", bg = "#22252A" },
   PmenuSel = { fg = "NONE", bg = "#282C34" },

   CmpItemMenu = { fg = "#C792EA", bg = "NONE", italic = true },

   CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
   CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE", bold = true },
   CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", bold = true },

   CmpItemKindClass = { fg = "#EADFF0", bg = "#A377BF" },
   CmpItemKindColor = { fg = "#D8EEEB", bg = "#58B5A8" },
   CmpItemKindConstant = { fg = "#FFE082", bg = "#D4BB6C" },
   CmpItemKindConstructor = { fg = "#FFE082", bg = "#D4BB6C" },
   CmpItemKindEnum = { fg = "#C3E88D", bg = "#9FBD73" },
   CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },
   CmpItemKindEvent = { fg = "#EED8DA", bg = "#B5585F" },
   CmpItemKindField = { fg = "#EED8DA", bg = "#B5585F" },
   CmpItemKindFile = { fg = "#C5CDD9", bg = "#7E8294" },
   CmpItemKindFolder = { fg = "#F5EBD9", bg = "#D4A959" },
   CmpItemKindFunction = { fg = "#EADFF0", bg = "#A377BF" },
   CmpItemKindInterface = { fg = "#D8EEEB", bg = "#58B5A8" },
   CmpItemKindKeyword = { fg = "#C3E88D", bg = "#9FBD73" },
   CmpItemKindMethod = { fg = "#DDE5F5", bg = "#6C8ED4" },
   CmpItemKindModule = { fg = "#EADFF0", bg = "#A377BF" },
   CmpItemKindOperator = { fg = "#EADFF0", bg = "#A377BF" },
   CmpItemKindProperty = { fg = "#EED8DA", bg = "#B5585F" },
   CmpItemKindReference = { fg = "#FFE082", bg = "#D4BB6C" },
   CmpItemKindSnippet = { fg = "#F5EBD9", bg = "#D4A959" },
   CmpItemKindStruct = { fg = "#EADFF0", bg = "#A377BF" },
   CmpItemKindText = { fg = "#C3E88D", bg = "#9FBD73" },
   CmpItemKindTypeParameter = { fg = "#D8EEEB", bg = "#58B5A8" },
   CmpItemKindUnit = { fg = "#F5EBD9", bg = "#D4A959" },
   CmpItemKindValue = { fg = "#DDE5F5", bg = "#6C8ED4" },
   CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
}

for group, info in pairs(M.cmp_highlight_groups) do
   vim.api.nvim_set_hl(0, group, info)
end

-- Setup cmp menu formatting
local lspkind_cmp_format = require("lspkind").cmp_format({
   mode = "symbol",
   preset = "default",
   maxwidth = {
      menu = function()
         return math.max(50, math.floor(vim.o.columns * 0.35))
      end,
   },
   ellipsis_char = "…",
})

M.cmp_formatting = {
   fields = {
      "kind",
      "abbr",
      "menu",
   },
   format = function(entry, vim_item)
      local orig_kind = vim_item.kind
      local item = lspkind_cmp_format(entry, vim_item)
      if item.kind == "" then
         item.kind = string.upper(string.sub(orig_kind, 1, 1))
      end
      -- Add some extra padding to the symbol
      item.kind = " " .. item.kind .. " "
      return item
   end,
}

M.cmp_window = {
   completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
   },
}

return M
