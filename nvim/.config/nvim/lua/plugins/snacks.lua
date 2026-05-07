return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		lazygit = {},
		terminal = {},
	},
	keys = {
		{ "<leader>gg", function() Snacks.lazygit() end,  desc = "Lazygit" },
		{ "<C-t>",      function() Snacks.terminal() end, desc = "Toggle Terminal", mode = { "n", "t" } },
	},
}
