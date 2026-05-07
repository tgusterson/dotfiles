return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		view_options = { show_hidden = true },
		keymaps = { ["<Esc>"] = "actions.close" },
	},
	config = function(_, opts)
		require("oil").setup(opts)

		-- If oil is already open, focus it and select top entry; otherwise open float
		local function oil_toggle_or_select()
			local actions = require("oil.actions")
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].filetype == "oil" then
					vim.api.nvim_set_current_win(win)
					vim.cmd("normal! gg")
					actions.select.callback()
					return
				end
			end
			vim.cmd("Oil --float")
		end

		vim.keymap.set("n", "<leader>\\", oil_toggle_or_select, { desc = "Oil: toggle file explorer" })
	end,
}
