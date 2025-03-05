local wezterm = require("wezterm")

local M = {}

-- Defaults
M.dpi = 96
M.fps = 60

-- For Windows shenanigans
M.is_windows = not not wezterm.target_triple:find("-windows-")

---Converts pixels to points
---@param px number
---@return number
function M.px_to_pt(px)
   return (px / M.dpi) / (1 / 72)
end

return M
