return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function() return vim.fn.executable("make") == 1 end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg", "--color=never", "--line-number", "--column",
					"--smart-case", "--fixed-strings", "--hidden",
				},
				file_ignore_patterns = {
					"node_modules", "__generated__", "dist", "%.git",
					"lock%.yaml", "lock%.json",
				},
				prompt_prefix = "🔍 > ",
				path_display = { "smart" },
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden" },
				},
			},
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
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

		-- Neovim 0.12 removed ft_to_lang; disable treesitter highlighting in previewer
		require("telescope.previewers.utils").ts_highlighter = function() end

		local builtin = require("telescope.builtin")
		local opts = { noremap = true, silent = true }
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, vim.tbl_extend("keep", opts, { desc = desc }))
		end

		map("<leader>t",  ":Telescope<CR>",                                  "Open Telescope")
		map("<leader>sh", builtin.help_tags,                                  "[S]earch [H]elp")
		map("<leader>sk", builtin.keymaps,                                    "[S]earch [K]eymaps")
		map("<leader>sf", builtin.find_files,                                 "[S]earch [F]iles")
		map("<leader>ss", builtin.builtin,                                    "[S]earch [S]elect Telescope")
		map("<leader>sw", builtin.grep_string,                                "[S]earch current [W]ord")
		map("<leader>sg", builtin.live_grep,                                  "[S]earch by [G]rep")
		map("<leader>sd", builtin.diagnostics,                                "[S]earch [D]iagnostics")
		map("<leader>sr", builtin.resume,                                     "[S]earch [R]esume")
		map("<leader>s.", builtin.oldfiles,                                   "[S]earch Recent Files")
		map("<leader>sb", builtin.buffers,                                    "[S]earch [B]uffers")
		map("<leader>sN", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, "[S]earch [N]eovim files")

		map("<leader>/", function()
			builtin.current_buffer_fuzzy_find(
				require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
			)
		end, "[/] Fuzzy search current buffer")

		map("<leader>s/", function()
			builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
		end, "[S]earch [/] in Open Files")

		map("<leader>sn", function()
			local notes_dir = os.getenv("NOTES_DIR") or vim.fn.expand("~/notes")
			if vim.fn.isdirectory(notes_dir) == 0 then
				vim.notify("Notes directory not found: " .. notes_dir, vim.log.levels.WARN)
				return
			end
			builtin.live_grep({ search_dirs = { notes_dir }, prompt_title = "Search Notes", additional_args = { "--no-ignore-vcs" } })
		end, "[S]earch [N]otes")

		map("<leader>en", function()
			local notes_dir = os.getenv("NOTES_DIR") or vim.fn.expand("~/notes")
			if vim.fn.isdirectory(notes_dir) == 0 then
				vim.notify("Notes directory not found: " .. notes_dir, vim.log.levels.WARN)
				return
			end
			builtin.find_files({ cwd = notes_dir, prompt_title = "Edit Note", no_ignore = true })
		end, "[E]dit [N]ote")

		map("<leader>ni", function()
			local notes_dir = os.getenv("NOTES_DIR") or vim.fn.expand("~/notes")
			vim.cmd("edit " .. notes_dir .. "/inbox.md")
		end, "[N]otes [I]nbox")
	end,
}
