return {
	-- Parser manager — configs module gone, highlighting is now native in 0.12
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false,
		lazy = false,
		build = ":TSUpdate",
		config = function()
			-- telescope uses nvim-treesitter.parsers.ft_to_lang and nvim-treesitter.configs.is_enabled
			-- both removed in new nvim-treesitter; stub them so telescope falls back to regex highlighting
			local parsers = require("nvim-treesitter.parsers")
			if not parsers.ft_to_lang then
				parsers.ft_to_lang = function(ft)
					return vim.treesitter.language.get_lang(ft) or ft
				end
			end
			if not package.loaded["nvim-treesitter.configs"] then
				package.loaded["nvim-treesitter.configs"] = {
					is_enabled = function() return false end,
				}
			end

			require("nvim-treesitter").install({
				"bash", "c", "css", "diff", "graphql", "html",
				"javascript", "typescript", "tsx",
				"json", "lua", "luadoc", "markdown", "markdown_inline",
				"python", "query", "rust", "sql", "toml",
				"vim", "vimdoc", "yaml",
			})

			-- Highlighting and indentation are native in 0.12 — enable per filetype
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			max_lines = 3,
			multiline_threshold = 1,
			trim_scope = "outer",
			mode = "topline",
		},
		keys = {
			{
				"[c",
				function() require("treesitter-context").go_to_context(vim.v.count1) end,
				desc = "Jump to context",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]o"] = "@block.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[o"] = "@block.outer",
					},
				},
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["ac"] = "@comment.outer",
						["ic"] = "@comment.inner",
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",
						["ao"] = "@block.outer",
						["io"] = "@block.inner",
					},
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "<c-v>",
					},
					include_surrounding_whitespace = true,
				},
			})
		end,
	},
}
