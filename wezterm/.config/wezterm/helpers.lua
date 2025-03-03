local M = {}

---Converts pixels to points
---@param px number
---@return number
function M.px_to_pt(px)
   return px * 0.75
end

return M
