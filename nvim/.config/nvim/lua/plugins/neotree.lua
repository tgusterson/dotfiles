return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "\\", "<CMD>Neotree toggle<CR>", desc = "Toggle Neotree" },
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				buffers = {
					follow_current_file = { enabled = true },
				},
				filesystem = {
					follow_current_file = { enabled = true },
				},
			})
		end,
	},
}
