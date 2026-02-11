return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>f', group = '[F]ormat', mode = { 'n' } },
      { '<leader>g', group = '[G]it',    mode = { 'n', 'v' } },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Keymaps",
    },
  },
}
