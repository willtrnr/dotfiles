local opt = vim.opt

opt.rtp:prepend(vim.fn.stdpath("config") .. "/lazy.nvim")

require("lazy").setup({
   specs = {
      { import = "plugins" },
   },
   dev = {
      path = "~/Projects",
   },
   install = {
      colorscheme = { "nord" },
   },
   performance = {
      rtp = {
         reset = false,
      },
   },
})
