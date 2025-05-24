return {
  "folke/tokyonight.nvim",
  enable = true,
  name = "tokyonight",
  lazy = false,
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'tokyonight-night'
  end,
}
