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

-- Animate cursor
require("smear_cursor").setup({})

-- LSP status
M.fidget = require("fidget")
M.fidget.setup({
   progress = {
      lsp = {
         progress_ringbuf_size = 128,
      },
   },
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
      },
      lualine_x = {
         "lsp_status",
         lualine_tabnine_status,
         "encoding",
         "fileformat",
         "filetype",
         lualine_yaml_schema,
      },
   },
   extensions = {
      "fugitive",
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

for k, v in pairs({
   IlluminatedWordText = { link = "LspReferenceText", default = true },
   IlluminatedWordRead = { link = "LspReferenceRead", default = true },
   IlluminatedWordWrite = { link = "LspReferenceWrite", default = true },
}) do
   vim.api.nvim_set_hl(0, k, v)
end

-- Setup diagnostic signs
for k, v in pairs({
   Error = "",
   Warn = "",
   Info = "",
   Hint = "󰟶",
}) do
   local hl = "DiagnosticSign" .. k
   vim.fn.sign_define(hl, {
      text = v,
      texthl = hl,
      numhl = hl,
   })
end

-- Extra lightbulb diagnostic
M.lightbulb_icon = "󱠃"

-- Setup cmp menu styling
for k, v in pairs({
   Pmenu = { fg = "#C5CDD9", bg = "#22252A" },
   PmenuSel = { fg = "NONE", bg = "#282C34" },

   CmpItemMenu = { fg = "#C792EA", bg = "NONE", italic = true },

   CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
   CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE", bold = true },
   CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", bold = true },
}) do
   vim.api.nvim_set_hl(0, k, v)
end

for k, v in pairs({
   Text = { fg = "#C3E88D", bg = "#9FBD73" },
   Method = { fg = "#DDE5F5", bg = "#6C8ED4" },
   Function = { fg = "#EADFF0", bg = "#A377BF" },
   Constructor = { fg = "#FFE082", bg = "#D4BB6C" },
   Field = { fg = "#EED8DA", bg = "#B5585F" },
   Variable = { fg = "#C5CDD9", bg = "#7E8294" },
   Class = { fg = "#EADFF0", bg = "#A377BF" },
   Interface = { fg = "#D8EEEB", bg = "#58B5A8" },
   Module = { fg = "#EADFF0", bg = "#A377BF" },
   Property = { fg = "#EED8DA", bg = "#B5585F" },
   Unit = { fg = "#F5EBD9", bg = "#D4A959" },
   Value = { fg = "#DDE5F5", bg = "#6C8ED4" },
   Enum = { fg = "#C3E88D", bg = "#9FBD73" },
   Keyword = { fg = "#C3E88D", bg = "#9FBD73" },
   Snippet = { fg = "#F5EBD9", bg = "#D4A959" },
   Color = { fg = "#D8EEEB", bg = "#58B5A8" },
   File = { fg = "#C5CDD9", bg = "#7E8294" },
   Reference = { fg = "#FFE082", bg = "#D4BB6C" },
   Folder = { fg = "#F5EBD9", bg = "#D4A959" },
   EnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },
   Constant = { fg = "#FFE082", bg = "#D4BB6C" },
   Struct = { fg = "#EADFF0", bg = "#A377BF" },
   Event = { fg = "#EED8DA", bg = "#B5585F" },
   Operator = { fg = "#EADFF0", bg = "#A377BF" },
   TypeParameter = { fg = "#D8EEEB", bg = "#58B5A8" },
}) do
   vim.api.nvim_set_hl(0, "CmpItemKind" .. k .. "Icon", v)
end

local lspkind = require("lspkind")

local lspkind_symbol_map = {}
for k, v in pairs(lspkind.symbol_map) do
   lspkind_symbol_map[k] = " " .. v .. " "
end

M.cmp_formatting = {
   fields = {
      "icon",
      "abbr",
      "menu",
   },
   format = lspkind.cmp_format({
      maxwidth = {
         menu = function()
            return math.max(50, math.floor(vim.o.columns * 0.35))
         end,
      },
      ellipsis_char = "…",
      show_labelDetails = true,
      symbol_map = lspkind_symbol_map,
   }),
}

M.cmp_window = {
   completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
   },
}

return M
