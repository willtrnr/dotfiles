--
-- Config Entrypoint
--

local util = require("util")

-- We will need to collect LSP capabilities as we setup plugins
local lsp_caps = vim.lsp.protocol.make_client_capabilities()

-- Make a group for all our custom autocmd
local augroup = vim.api.nvim_create_augroup("usercmd", { clear = true })

--
-- Rice our ride first
--

local ricing = require("config.ricing")
lsp_caps = util.update_capabilities(lsp_caps, ricing.lsp_status.capabilities)

--
-- QOL stuff
--

local snacks = require("snacks")
snacks.setup({
   bigfile = {
      enabled = true,
      size = 2 * 1024 * 1024, -- 2MiB
      line_length = 1000,
      notify = true,
   },
   dashboard = {
      enabled = true,
      sections = {
         { section = "header" },
         {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            cwd = true,
            indent = 2,
            padding = 1,
         },
      },
   },
   explorer = { enabled = true },
   git = { enabled = true },
   image = { enabled = true },
   indent = {
      enabled = true,
      indent = {
         enabled = true,
         char = "┆",
      },
      scope = {
         enabled = true,
         char = "┆",
         hl = "SnacksIndent2",
      },
   },
   input = {
      enabled = true,
      icon_pos = "title",
   },
   notifier = {
      enabled = true,
      width = {
         min = 40,
         max = 0.35,
      },
      height = {
         min = 1,
         max = 0.4,
      },
      margin = {
         top = 0,
         right = 0,
         bottom = 1,
      },
      level = vim.log.levels.INFO,
      style = "fancy",
      top_down = false,
   },
   notify = { enabled = true },
   picker = { enabled = true },
   rename = { enabled = true },
   scope = { enabled = true },
   scroll = { enabled = false },
   styles = {
      input = {
         title_pos = "left",
         relative = "cursor",
         width = 40,
         row = -3,
         col = -1,
      },
   },
})

-- Toggle terminal on ctrl-\
util.noremap({ "n", "t" }, [[<C-\>]], function()
   snacks.terminal.toggle(nil, {
      win = {
         height = 0.25,
         wo = {
            winbar = "",
         },
      },
   })
end)

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
   group = augroup,
   callback = function()
      vim.highlight.on_yank({
         timeout = 500,
         on_visual = false,
      })
   end,
})

-- Use TreeSitter for better highlight
require("nvim-treesitter.configs").setup({ ---@diagnostic disable-line: missing-fields
   auto_install = true,
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

--
-- Navigation
--

util.noremap("n", "<leader>t", snacks.explorer.open)

-- Telescope finders and menus
local telescope = require("telescope")
local telescope_config = require("telescope.config")
local telescope_actions = require("telescope.actions")
telescope.setup({
   defaults = {
      mappings = {
         i = {
            -- Directly close on <esc> instead of going to normal
            ["<esc>"] = telescope_actions.close,
         },
      },
      vimgrep_arguments = util.list_concat(
      -- Include dotfiles in search
         telescope_config.values.vimgrep_arguments,
         {
            "--hidden",
            "--glob",
            "!.git/*",
         }
      ),
   },
   pickers = {
      find_files = {
         find_command = {
            "rg",
            "--files",
            "--color",
            "never",
            -- We need to manually inject this with hidden=true
            "--glob",
            "!.git/*",
         },
         hidden = true,
      },
   },
   extensions = {
      lsp_handlers = {
         disable = {
            -- Broken in recent versions, handled by Dressing instead
            ["textDocument/codeAction"] = true,
         },
      },
   },
})
telescope.load_extension("fzf")
telescope.load_extension("lsp_handlers")

local telescope_builtin = require("telescope.builtin")
util.noremap("n", "<leader><Tab>", telescope_builtin.find_files)
util.noremap("n", "<leader><S-Tab>", telescope_builtin.live_grep)

--
-- Completion
--

-- Setup crates.io version completion and annotations
require("crates").setup({})

-- Setup cmp for completion
local cmp = require("cmp")
cmp.setup({
   formatting = ricing.cmp_formatting,
   mapping = cmp.mapping.preset.insert({
      -- Call up the autocomplete on <ctrl-space>
      ["<C-Space>"] = cmp.mapping.complete(),
      -- Accept the explicitly selected option
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
      -- Accept the first or selected option
      ["<Tab>"] = cmp.mapping.confirm({ select = true }),
   }),
   snippet = {
      expand = function(args)
         vim.fn["vsnip#anonymous"](args.body)
      end,
   },
   sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "calc" },
      -- { name = "t9cmp" },
      { name = "crates" },
      { name = "path" },
   }, {
      { name = "buffer" },
   }),
   window = ricing.cmp_window,
})

-- Extend the LSP caps with the cmp caps
local cmp_lsp = require("cmp_nvim_lsp")
lsp_caps = util.update_capabilities(lsp_caps, cmp_lsp.default_capabilities())

-- Setup Tabnine autocomplete
require("tabnine.chat.setup").setup = util.noop -- HACK: Noop the chat agent setup function to disable it
require("tabnine").setup({
   accept_keymap = "<NL>",
})

--
-- Diagnostics
--

-- Only show virtual text for warnings and above
vim.diagnostic.config({
   underline = true,
   virtual_text = {
      severity = {
         min = vim.diagnostic.severity.WARN,
      },
   },
})

-- Diagnostics navigation
util.noremap("n", "g[", function() vim.diagnostic.jump({ count = -1 }) end)
util.noremap("n", "g]", function() vim.diagnostic.jump({ count = 1 }) end)

-- Show diagnostic at cursor position in a floating window
vim.api.nvim_create_autocmd("CursorHold", {
   group = augroup,
   callback = function()
      vim.diagnostic.open_float(nil, {
         focusable = false,
         close_events = {
            "BufLeave",
            "CursorMoved",
            "InsertEnter",
         },
         scope = "cursor",
         source = "if_many",
      })
   end,
})

--
-- LSP
--

-- Code actions indicator
local lightbulb = require("nvim-lightbulb")
lightbulb.setup({ ---@diagnostic disable-line: missing-fields
   sign = {
      text = ricing.lightbulb_icon,
   },
})

local function lsp_on_attach(client, bufnr)
   local caps = client.server_capabilities

   local function lsp_nmap(cap, key, action)
      if caps[cap] then
         util.noremap("n", key, action, bufnr)
      end
   end

   -- Attach the client to lsp-status
   ricing.lsp_status.on_attach(client)

   -- Show symbol documentation
   lsp_nmap("hoverProvider", "<leader>d", vim.lsp.buf.hover)

   -- Show signature help
   lsp_nmap("signatureHelpProvider", "<C-s>", vim.lsp.buf.signature_help)

   -- Code navigation
   lsp_nmap("definitionProvider", "gd", vim.lsp.buf.definition)
   lsp_nmap("typeDefinitionProvider", "gy", vim.lsp.buf.type_definition)
   lsp_nmap("implementationProvider", "gi", vim.lsp.buf.implementation)
   lsp_nmap("referencesProvider", "gr", vim.lsp.buf.references)

   -- Rename symbol
   lsp_nmap("renameProvider", "<leader>r", vim.lsp.buf.rename)

   -- Format
   lsp_nmap("documentFormattingProvider", "<leader>f", vim.lsp.buf.format or vim.lsp.buf.formatting)

   -- Code actions
   if caps.codeActionProvider then
      util.noremap("n", "<leader>a", vim.lsp.buf.code_action, bufnr)
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
         group = augroup,
         buffer = bufnr,
         callback = util.thunkify(lightbulb.update_lightbulb),
      })
   end

   -- Code lens
   if caps.codeLensProvider then
      util.noremap("n", "<leader>l", vim.lsp.codelens.run, bufnr)
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
         group = augroup,
         buffer = bufnr,
         callback = util.thunkify(vim.lsp.codelens.refresh),
      })
   end
end

-- Mason package manager for LSP servers and linters
require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
   -- This key does not exist on mason-lspconfig < 2.x so will be ignored
   automatic_enable = {
      exclude = {
         -- Handled by Rustaceanvim
         "rust-analyzer",
      },
   },
})

if vim.fn.has("nvim-0.11") == 1 then
   vim.api.nvim_create_autocmd("LspAttach", {
      group = augroup,
      callback = function(args)
         return lsp_on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
      end,
   })

   vim.lsp.config("*", {
      capabilities = lsp_caps,
   })

   vim.lsp.config("jsonls", {
      settings = {
         json = {
            validate = true,
         },
      },
      before_init = function(_params, config)
         config.settings.json.schemas = require("schemastore").json.schemas()
      end,
   })

   vim.lsp.config("yamlls", {
      settings = {
         yaml = {
            format = {
               enable = true,
            },
            validate = true,
            completion = true,
            schemaStore = {
               enable = false
            },
         },
      },
      before_init = function(_params, config)
         config.settings.yaml.schemas = require("schemastore").yaml.schemas()
      end,
   })
else
   local lspconfig = require("lspconfig")

   mason_lspconfig.setup_handlers({
      function(server_name)
         lspconfig[server_name].setup({
            capabilities = lsp_caps,
            on_attach = lsp_on_attach,
         })
      end,
      ["jsonls"] = function()
         lspconfig.jsonls.setup({
            capabilities = lsp_caps,
            on_attach = lsp_on_attach,
            settings = {
               json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = {
                     enable = true,
                  },
               },
            },
         })
      end,
      ["yamlls"] = function()
         lspconfig.yamlls.setup(require("yaml-companion").setup({
            lspconfig = {
               capabilities = lsp_caps,
               on_attach = lsp_on_attach,
               settings = {
                  yaml = {
                     schemaStore = {
                        enable = false,
                        url = "",
                     },
                     schemas = require("schemastore").yaml.schemas(),
                     trace = {
                        server = "info",
                     },
                  },
               },
            },
         }))
      end,
      ["omnisharp"] = function()
         lspconfig.omnisharp.setup({
            capabilities = lsp_caps,
            on_attach = function(client, bufnr)
               -- For some reason OmniSharp mis-represents its capabilities, so patch it here
               client.server_capabilities = util.update_capabilities(client.server_capabilities, {
                  codeActionProvider = vim.empty_dict(),
                  definitionProvider = true,
                  documentFormattingProvider = true,
                  documentRangeFormattingProvider = true,
                  hoverProvider = true,
                  renameProvider = vim.empty_dict(),
               })

               return lsp_on_attach(client, bufnr)
            end,
            settings = {
               formattingOptions = {
                  enableEditorConfigSupport = true,
                  organizeImports = true,
               },
               msbuild = {
                  loadProjectsOnDemand = false,
               },
               roslynExtensionsOptions = {
                  enableAnalyzerSupport = true,
                  enableDecompilationSupport = true,
                  enableImportCompletion = true,
               },
            },
         })
      end,
      ["luau_lsp"] = function()
         require("luau-lsp").setup({ ---@diagnostic disable-line: missing-fields
            platform = {
               type = "standard",
            },
            sourcemap = {
               enabled = false,
            },
            types = {
               roblox_security_level = "None",
            },
            fflags = {
               enable_new_solver = true,
            },
            server = {
               capabilities = lsp_caps,
               on_attach = lsp_on_attach,
            },
         })
      end,
   })
end

-- Rustaceanvim uses this weird global config thing
vim.g.rustaceanvim = { ---@type rustaceanvim.Config
   tools = {
      rustc = {
         default_edition = "2024",
      },
   },
   server = {
      capabilities = lsp_caps,
      standalone = false,
   },
   dap = {
      autoload_configurations = false,
   },
}

vim.api.nvim_create_autocmd("FileType", {
   group = vim.api.nvim_create_augroup("nvim-metals", {
      clear = true,
   }),
   pattern = {
      "sbt",
      "scala",
   },
   callback = function()
      require("metals").initialize_or_attach({
         capabilities = lsp_caps,
         on_attach = lsp_on_attach,
         handlers = require("config.metals_lsp_status").setup(),
         init_options = {
            compilerOptions = vim.empty_dict(),
            statusBarProvider = "on",
         },
         settings = {
            showImplicitArguments = true,
         },
         tvp = vim.empty_dict(),
      })
   end,
})

require("nvim-dap-virtual-text").setup({ ---@diagnostic disable-line: missing-fields
   enabled = true,
})
