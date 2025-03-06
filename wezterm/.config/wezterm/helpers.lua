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
   if not M.running_on_windows() then
      local success, ret = pcall(wezterm.run_child_process, {
         "systemd-detect-virt", "--vm", "--quiet"
      })
      return success and ret
   else
      -- Probably won't matter here
      return false
   end
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

---@generic K, V
---@param key K
---@return fun(t: table<K, V>): V?
function M.getter(key)
   return function(t) return t[key] end
end

---@generic T, U
---@param it T[]
---@param fn fun(value: T): U
---@return U[]
function M.map(it, fn)
   local acc = {}
   for _, v in ipairs(it) do
      table.insert(acc, fn(v))
   end
   return acc
end

---@generic K, T, U
---@param it table<K, T>
---@param fn fun(value: T, key: K): U
---@return table<K, U>
function M.map_values(it, fn)
   local acc = {}
   for k, v in pairs(it) do
      acc[k] = fn(v, k)
   end
   return acc
end

---@generic T
---@param it T[]
---@param pred fun(value: T): boolean?
---@return T[]
function M.filter(it, pred)
   local acc = {}
   for _, v in ipairs(it) do
      if pred(v) then
         table.insert(acc, v)
      end
   end
   return acc
end

---@generic T
---@param it T[]
---@param pred fun(value: T): boolean?
---@return T[], T[]
function M.partition(it, pred)
   local acc_true = {}
   local acc_false = {}
   for _, v in ipairs(it) do
      if pred(v) then
         table.insert(acc_true, v)
      else
         table.insert(acc_false, v)
      end
   end
   return acc_true, acc_false
end

---@generic T
---@param it T[]
---@param pred fun(value: T): boolean?
---@return T?
function M.find(it, pred)
   for _, v in ipairs(it) do
      if pred(v) then
         return v
      end
   end
end

---@generic T
---@param head T?
---@vararg T?
---@return T?
function M.coalesce(head, ...)
   if head then
      return head
   end
   for _, v in ipairs({ ... }) do
      if v then
         return v
      end
   end
end

M.predicates = {}

---@generic T
---@param lhs T
---@return fun(rhs: T): boolean
function M.predicates.eq(lhs)
   return function(rhs) return lhs == rhs end
end

---@generic T
---@param lhs T
---@return fun(rhs: T): boolean
function M.predicates.ne(lhs)
   return function(rhs) return lhs ~= rhs end
end

---@param lhs string
---@return fun(rhs: string): boolean
function M.predicates.starts_with(lhs)
   return function(rhs) return not not rhs:find(lhs) end
end

---@generic T
---@param a fun(lhs: T): boolean
---@param b fun(lhs: T): boolean
---@return fun(rhs: T): boolean
function M.predicates._and(a, b)
   return function(rhs) return a(rhs) and b(rhs) end
end

---@generic T
---@param a fun(lhs: T): boolean
---@param b fun(lhs: T): boolean
---@return fun(rhs: T): boolean
function M.predicates._or(a, b)
   return function(rhs) return a(rhs) or b(rhs) end
end

return M
