local wezterm = require("wezterm")

local helpers = require("helpers")

return helpers.doto(wezterm.config_builder(), function(config)
   config.term = "wezterm"

   -- Standard ricing
   config.color_scheme = "nord"

   -- Font config
   config.font = wezterm.font_with_fallback({ "TX02 Nerd Font Mono", "TX-02", "monospace" })
   config.font_size = helpers.px_to_pt(14)
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

   -- Graphic config
   if wezterm.gui and not helpers.running_in_vm() then
      -- Find actual GPUs
      local gpus = helpers.filter(wezterm.gui.enumerate_gpus(), function(gpu)
         return gpu.device_type ~= "Cpu"
      end)

      -- Select the integrated if available, otherwise dedicated, or else let if default on its own
      local gpu = helpers.coalesce(
         helpers.find(gpus, function(gpu)
            return gpu.device_type == "IntegratedGpu" and gpu.backend == "Vulkan"
         end),
         helpers.find(gpus, function(gpu)
            return gpu.device_type == "IntegratedGpu" and gpu.backend:find("^Dx")
         end),
         helpers.find(gpus, function(gpu)
            return gpu.backend == "Vulkan"
         end),
         helpers.find(gpus, function(gpu)
            return gpu.backend:find("^Dx")
         end)
      )

      if gpu ~= nil then
         config.webgpu_preferred_adapter = gpu
         config.front_end = "WebGpu"
      end
   end
end)
