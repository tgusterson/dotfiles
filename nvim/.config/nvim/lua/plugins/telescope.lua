return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--line-number",
					"--column",
					-- "--ignore-case",
					"--smart-case",
					"--fixed-strings",
					"--hidden",
				},

				file_ignore_patterns = {
					"node_modules",
					"__generated__",
					"dist",
					"%.git",
					"lock%.yaml",
					"lock%.json",
				},

				prompt_prefix = "🔍 > ",
				path_display = { "smart" },
			},

			pickers = {
				find_files = {
					find_command = {
						"rg",
						"--files",
						"--hidden",
					},
				},
			},

			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "ignore_case",
				},
			},
		})

		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		local builtin = require("telescope.builtin")
		local opts = { noremap = true, silent = true }

		vim.keymap.set("n", "<leader>sh", builtin.help_tags, vim.tbl_extend("keep", opts, { desc = "[S]earch [H]elp" }))
		vim.keymap.set(
			"n",
			"<leader>sk",
			builtin.keymaps,
			vim.tbl_extend("keep", opts, { desc = "[S]earch [K]eymaps" })
		)
		vim.keymap.set(
			"n",
			"<leader>sf",
			builtin.find_files,
			vim.tbl_extend("keep", opts, { desc = "[S]earch [F]iles" })
		)
		vim.keymap.set(
			"n",
			"<leader>ss",
			builtin.builtin,
			vim.tbl_extend("keep", opts, { desc = "[S]earch [S]elect Telescope" })
		)
		vim.keymap.set(
			"n",
			"<leader>sw",
			builtin.grep_string,
			vim.tbl_extend("keep", opts, { desc = "[S]earch current [W]ord" })
		)
		vim.keymap.set(
			"n",
			"<leader>sg",
			builtin.live_grep,
			vim.tbl_extend("keep", opts, { desc = "[S]earch by [G]rep" })
		)
		vim.keymap.set(
			"n",
			"<leader>sd",
			builtin.diagnostics,
			vim.tbl_extend("keep", opts, { desc = "[S]earch [D]iagnostics" })
		)
		vim.keymap.set("n", "<leader>sr", builtin.resume, vim.tbl_extend("keep", opts, { desc = "[S]earch [R]esume" }))
		vim.keymap.set(
			"n",
			"<leader>s.",
			builtin.oldfiles,
			vim.tbl_extend("keep", opts, { desc = '[S]earch Recent Files ("." for repeat)' })
		)
		vim.keymap.set(
			"n",
			"<leader>sb",
			builtin.buffers,
			vim.tbl_extend("keep", opts, { desc = "[S]earch [B]uffers" })
		)
		vim.keymap.set("n", "<leader>t", ":Telescope<CR>", vim.tbl_extend("keep", opts, { desc = "Open Telescope" }))
		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(
				require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
			)
		end, vim.tbl_extend("keep", opts, { desc = "[/] Fuzzily search in current buffer" }))
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
		end, vim.tbl_extend("keep", opts, { desc = "[S]earch [/] in Open Files" }))
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, vim.tbl_extend("keep", opts, { desc = "[S]earch [N]eovim files" }))
	end,
}
