local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.term = "wezterm"

config.color_scheme = "nord"

config.font = wezterm.font("monospace")
config.font_size = 11.5
config.underline_thickness = 1

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.enable_scroll_bar = false

config.front_end = "Software"
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

config.window_frame = {
   font = wezterm.font("monospace"),
   font_size = 8.0,
}

config.window_padding = {
   left = 0,
   right = 0,
   top = 0,
   bottom = 0,
}

config.check_for_updates = false

return config
