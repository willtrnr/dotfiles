--
-- General utilities
--

local M = {}

---Capitalize the first character in a string
---@param s string
---@return string
function M.capitalize(s)
   return string.upper(string.sub(s, 1, 1)) .. string.sub(s, 2)
end

---Partially apply a function with a given argument
---@generic T, U
---@param fn fun(T, ...):U
---@param x T
---@return fun(...):U
function M.partial(fn, x)
   return function(...)
      return fn(x, ...)
   end
end

---Create a thunk discarding any argument and return value for a function
---@param fn function
---@return fun()
function M.thunkify(fn)
   return function()
      fn()
   end
end

---Apply a side-effecting function to a value, then return the value
---@generic T
---@param value T
---@param fn fun(T)
---@return T
function M.doto(value, fn)
   fn(value)
   return value
end

---Concatenate two list-like tables into a new table
---@generic T
---@param a T[]
---@param b T[]
---@return T[]
function M.list_concat(a, b)
   return vim.list_extend(vim.list_extend({}, a), b)
end

--- Update LSP capabilities and return result
---@param a lsp.ClientCapabilities
---@param b lsp.ClientCapabilities
---@return lsp.ClientCapabilities
function M.update_capabilities(a, b)
   return vim.tbl_deep_extend("keep", a, b)
end

---Shorthand to map key silent
---@param mode string|string[]
---@param key string
---@param cb string|function|nil
---@param bufnr? integer|boolean|vim.keymap.set.Opts
---@param no_thunk? boolean
function M.noremap(mode, key, cb, bufnr, no_thunk)
   if not cb then
      return
   end

   local opts = { --[[@type vim.keymap.set.Opts]]
      noremap = true,
      silent = true,
   }

   if bufnr then
      if type(bufnr) == "table" then
         opts = vim.tbl_extend("keep", bufnr, opts)
      else
         ---@cast bufnr boolean|integer
         opts.buffer = bufnr
      end
   end

   -- Auto-thunk the callback function
   if not no_thunk and type(cb) == "function" then
      cb = M.thunkify(cb)
   end

   vim.keymap.set(mode, key, cb, opts)
end

return M
