local wezterm = require("wezterm")

local helpers = require("helpers")

local config = wezterm.config_builder()

config.term = "wezterm"

config.color_scheme = "nord"

config.font = wezterm.font("Monospace")
config.font_size = helpers.px_to_pt(14)
config.cell_width = 1
config.line_height = 1.05
config.underline_thickness = 1
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.scrollback_lines = 10000
config.enable_scroll_bar = false

config.max_fps = 144
config.front_end = "OpenGL"
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.audible_bell = "Disabled"

config.window_frame = {
   font = config.font,
   font_size = config.font_size,
}

config.window_padding = {
   left = 2,
   right = 2,
   top = 2,
   bottom = 2,
}

config.check_for_updates = false

return config
