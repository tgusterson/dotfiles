return {
	{ "tpope/vim-fugitive" },

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			signs = {
				add          = { text = "+" },
				change       = { text = "~" },
				delete       = { text = "_" },
				topdelete    = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				map("n", "<leader>gcn", function()
					if vim.wo.diff then vim.cmd.normal({ "<leader>gcn", bang = true })
					else gitsigns.nav_hunk("next") end
				end, "Next git change")

				map("n", "<leader>gcp", function()
					if vim.wo.diff then vim.cmd.normal({ "<leader>gcp", bang = true })
					else gitsigns.nav_hunk("prev") end
				end, "Prev git change")

				-- Staging
				map("v", "<leader>gs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
				map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
				map("n", "<leader>gs", gitsigns.stage_hunk,   "Stage hunk")
				map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
				map("n", "<leader>gr", gitsigns.reset_hunk,   "Reset hunk")
				map("n", "<leader>gu", gitsigns.stage_hunk,   "Undo stage hunk")
				map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")
				map("n", "<leader>gp", gitsigns.preview_hunk, "Preview hunk")
				map("n", "<leader>gb", gitsigns.blame_line,   "Blame line")

				-- Diff
				map("n", "<leader>gd", function()
					if vim.wo.diff then
						local current = vim.api.nvim_get_current_win()
						for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
							if win ~= current and vim.wo[win].diff then
								vim.api.nvim_win_close(win, false)
								break
							end
						end
						vim.cmd("diffoff")
					else
						gitsigns.diffthis()
					end
				end, "Diff against index")
				map("n", "<leader>gD", function() gitsigns.diffthis("@") end, "Diff against last commit")

				-- Toggles
				map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, "Toggle blame")
				map("n", "<leader>gtd", gitsigns.preview_hunk_inline,       "Toggle deleted")
			end,
		},
	},
}
