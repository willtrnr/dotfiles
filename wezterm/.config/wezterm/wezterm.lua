local wezterm = require("wezterm")
local helpers = require("helpers")

local config = wezterm.config_builder()

config.term = "wezterm"

-- Standard ricing
config.color_scheme = "nord"

-- Font config
config.font = wezterm.font("TX-02")
config.font_size = helpers.px_to_pt(14)
config.command_palette_font_size = config.font_size
config.underline_thickness = 1

config.freetype_load_flags = "NO_BITMAP|FORCE_AUTOHINT"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

-- Adjusting line height breaks AA on windows
if not helpers.is_windows then
   config.line_height = 1.05
end

-- Tab bar config
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Scroll config
config.scrollback_lines = 25000
config.enable_scroll_bar = false

-- Perf tuning
config.max_fps = helpers.fps
config.front_end = "OpenGL"
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Bell feedback config
config.audible_bell = "Disabled"

-- Window config
config.window_frame = { font = config.font, font_size = config.font_size }
config.window_padding = { left = 2, right = 2, top = 2, bottom = 2 }

-- Launch into WSL by default on Windows
if helpers.is_windows then
   config.wsl_domains = wezterm.default_wsl_domains()
   if config.wsl_domains[1] ~= nil then
      config.default_domain = config.wsl_domains[1].name
   end
end

-- Disable update checks, we have a package manager for that
config.check_for_updates = false

return config
