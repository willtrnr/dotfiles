--
-- General utilities
--

local M = {}

M.unpack = table.unpack or unpack

---No-op singleton function
function M.noop() end

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

---Create a thunk discarding any argument and return value of a function
---@param fn function
---@return fun(...)
function M.thunk(fn)
   return function(...)
      fn()
   end
end

---Return value as-is if not nil, otherwise return a default value
---@generic T
---@param value T|nil
---@param default T
---@return T
function M.if_nil(value, default)
   if value == nil then
      return default
   end
   return value
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

---Compute the set union of two lists-like tables
---@generic T
---@param a T[]
---@param b T[]
---@return T[]
function M.set_union(a, b)
   local set = {}
   if a then
      for _, v in ipairs(a) do
         set[v] = true
      end
   end
   if b then
      for _, v in ipairs(b) do
         set[v] = true
      end
   end
   return vim.tbl_keys(set)
end

---Combine LSP capabilities and return result
---@param a lsp.ClientCapabilities
---@param b lsp.ClientCapabilities
---@return lsp.ClientCapabilities
function M.update_caps(a, b)
   return vim.tbl_deep_extend("keep", {}, a, b)
end

---Shorthand to map key silent
---@param mode string|string[]
---@param key string
---@param cb string|function|nil
---@param bufnr? integer|boolean|vim.keymap.set.Opts
function M.noremap(mode, key, cb, bufnr)
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

   vim.keymap.set(mode, key, cb, opts)
end

---Nicer API for IIFE scope pattern
---@generic T
---@param fn fun(): T
---@return T
function M.iife(fn)
   return fn()
end

---Capitalize the first character in a string
---@param s string
---@return string
function M.capitalize(s)
   return string.upper(string.sub(s, 1, 1)) .. string.sub(s, 2)
end

return M
