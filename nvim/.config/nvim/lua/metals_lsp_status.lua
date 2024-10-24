--
-- lsp-status integration for nvim-metals
--

local lsp_status_util = require('lsp-status.util')
local lsp_status_redraw = require('lsp-status.redraw')

local M = {}

M._messages = {}

function M._init(messages)
   M._messages = messages
end

M._handlers = {
   ['metals/status'] = function(_, status, ctx)
      lsp_status_util.ensure_init(M._messages, ctx.client_id, 'metals')
      M._messages[ctx.client_id].status = {
         content = status.show and status.text or "",
      }
      lsp_status_redraw.redraw()
   end,
}

--
-- HACK: Inject our init in the clangd init
--
local ext = require('lsp-status.extensions.clangd')

local super_init = ext._init
function ext._init(messages, config)
   super_init(messages, config)
   M._init(messages)
end

function M.setup()
   -- Trigger the hacked init
   require('lsp-status').config({})
   return M._handlers
end

return M
