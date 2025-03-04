local wezterm = require("wezterm")

local M = {}

M.is_windows = not not wezterm.target_triple:find("-windows-")

---Converts pixels to points
---@param px number
---@return number
function M.px_to_pt(px)
   return px * 0.75
end

return M
