return {
	"jiaoshijie/undotree",
	dependencies = "nvim-lua/plenary.nvim",
	config = true,
	keys = { -- load the plugin only when using its keybinding:
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle [U]ndotree" },
	},
}
