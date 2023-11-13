--
-- General utilities
--

local M = {}

--- Capitalize the first character in a string
function M.capitalize(s)
   return s:sub(1, 1):upper() .. s:sub(2)
end

--- Partially apply a function with a given argument
function M.partial(fn, x)
   return function(...)
      return fn(x, ...)
   end
end

--- Create a thunk discarding any argument and return value for a function
function M.thunkify(fn)
   return function() fn() end
end

--- Concatenate two list-like tables into a new table
function M.list_concat(a, b)
   return vim.list_extend(vim.list_extend({}, a), b)
end

--- Update LSP capabilities and return result
function M.update_capabilities(a, b)
   return vim.tbl_deep_extend('keep', a, b)
end

--- Shorthand to map key silent
function M.noremap(mode, key, cb, bufnr, no_thunk)
   if not cb then return end

   local opts = {
      noremap = true,
      silent = true,
   }

   if bufnr then
      if type(bufnr) == 'table' then
         opts = vim.tbl_extend('keep', bufnr, opts)
      else
         opts.buffer = bufnr
      end
   end

   -- Auto-thunk the callback function
   if not no_thunk and type(cb) == 'function' then
      cb = M.thunkify(cb)
   end

   vim.keymap.set(mode, key, cb, opts)
end

return M
