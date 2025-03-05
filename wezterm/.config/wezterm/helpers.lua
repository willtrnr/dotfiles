local wezterm = require("wezterm")

local M = {}

-- Defaults
M.dpi = 96

---Converts pixels to points
---@param px number
---@return number
function M.px_to_pt(px)
   return (px / M.dpi) / (1 / 72)
end

---@generic T
---@param fn fun(): T
---@return fun(): T
function M.memoized(fn)
   local value = nil
   return function()
      if value == nil then
         value = fn()
      end
      return value
   end
end

-- For Windows shenanigans
M.running_on_windows = M.memoized(function()
   return not not wezterm.target_triple:find("-windows-")
end)

M.running_in_vm = M.memoized(function()
   ---@type boolean
   local value = wezterm.run_child_process({ "systemd-detect-virt", "--vm", "--quiet" })
   return value
end)

---@generic T
---@param cond any
---@param if_true T
---@param if_false T
---@return T
function M.ternary(cond, if_true, if_false)
   if cond then
      return if_true
   else
      return if_false
   end
end

---@generic T
---@param value T
---@param fn fun(value: T)
---@return T
function M.doto(value, fn)
   fn(value)
   return value
end

---@generic T
---@param it T[]
---@param pred fun(value: T): boolean?
---@return T[]
function M.filter(it, pred)
   local res = {}
   for _, v in ipairs(it) do
      if pred(v) then
         table.insert(res, v)
      end
   end
   return res
end

return M
