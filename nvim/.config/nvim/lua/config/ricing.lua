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
         "filetype",
         lualine_yaml_schema,
         "encoding",
         "fileformat",
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

return M
