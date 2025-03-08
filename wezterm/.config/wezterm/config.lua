local wezterm = require("wezterm")
local helpers = require("helpers")

local config = wezterm.config_builder()

config.term = "wezterm"

-- Standard ricing
config.color_scheme = "nord"

-- Font config
config.font = wezterm.font("TX02 Nerd Font Mono")
config.font_size = 10.5
config.command_palette_font_size = config.font_size
config.freetype_load_target = "Light"
config.freetype_render_target = "Light"
config.underline_thickness = 1

-- Tab bar config
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Scroll config
config.scrollback_lines = 25000
config.enable_scroll_bar = false

-- Bell feedback config
config.audible_bell = "Disabled"

-- Perf tuning
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Window config
config.window_frame = { font = config.font, font_size = config.font_size }
config.window_padding = { left = 2, right = 2, top = 2, bottom = 2 }
config.adjust_window_size_when_changing_font_size = false

-- Disable update checks, we have a package manager for that
config.check_for_updates = false

-- Launch into WSL by default on Windows
if helpers.running_on_windows() then
   config.wsl_domains = wezterm.default_wsl_domains()
   if config.wsl_domains[1] ~= nil then
      config.default_domain = config.wsl_domains[1].name
   end
end

-- GUI mode config
if wezterm.gui then
   -- Remove key bindings using the SUPER from the default, reserved for the WM
   config.keys = helpers.filter(wezterm.gui.default_keys(), function(k)
      return not k.mods or not k.mods:find("SUPER")
   end)
   config.key_tables = helpers.map_values(wezterm.gui.default_key_tables(), function(t)
      return helpers.filter(t, function(k)
         return not k.mods or not k.mods:find("SUPER")
      end)
   end)
   config.disable_default_key_bindings = true

   -- Select the integrated if available, otherwise dedicated, or else whatever GL
   local gpu = helpers.priority_find(
      helpers.filter(
         wezterm.gui.enumerate_gpus(),
         helpers.ternary(
            helpers.running_on_windows() or helpers.running_in_vm(),
            function(g)
               -- Ignore Vulkan backend on Windows and in VMs
               return g.device_type ~= "Cpu" and g.backend ~= "Vulkan"
            end,
            function(g)
               return g.device_type ~= "Cpu"
            end
         )
      ),
      function(g)
         return g.device_type == "IntegratedGpu" and g.backend == "Vulkan"
      end,
      function(g)
         return g.device_type == "IntegratedGpu" and g.backend:find("^Dx")
      end,
      function(g)
         return g.backend == "Vulkan"
      end,
      function(g)
         return g.backend:find("^Dx")
      end,
      function(g)
         return g.backend == "Gl"
      end
   )

   if gpu ~= nil then
      config.webgpu_preferred_adapter = gpu
      config.front_end = "WebGpu"
   end
end

return config
