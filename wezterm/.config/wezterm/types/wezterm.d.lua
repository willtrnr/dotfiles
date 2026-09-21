---@meta

---@class Key
---@field key string
---@field mods? string
---@field action any
local Key = {}

---@class WslDomain
---@field name string
---@field distribution string
---@field username? string
---@field default_cwd? string
---@field default_prog? string[]
local WslDomain = {}

local wezterm = {}

---@return table<string, any>
function wezterm.config_builder() end

---@param family string
---@param attributes? table<string, string>
---@return unknown
function wezterm.font(family, attributes) end

---@param families (string|table<string, string>)[]
---@param attributes? table<string, string>
---@return unknown
function wezterm.font_with_fallback(families, attributes) end

---@return boolean
function wezterm.running_under_wsl() end

---@return WslDomain[]
function wezterm.default_wsl_domains() end

return wezterm
