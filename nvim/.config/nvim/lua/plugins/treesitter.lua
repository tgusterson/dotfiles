return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				multiwindow = false, -- Enable multiwindow support.
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 1, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})

			vim.keymap.set("n", "[c", function()
				require("treesitter-context").go_to_context(vim.v.count1)
			end, { silent = true, desc = "Jump to context" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

			-- Register CFML parser (for .cfc files - ColdFusion Components)
			parser_config.cfml = {
				install_info = {
					url = "https://github.com/cfmleditor/tree-sitter-cfml",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
					generate_requires_npm = false,
					requires_generate_from_grammar = false,
					location = "cfml",
				},
				filetype = "cfml",
			}

			-- Register CFScript parser (for .cfs and .cfc files - pure CFScript)
			parser_config.cfscript = {
				install_info = {
					url = "https://github.com/cfmleditor/tree-sitter-cfml",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
					generate_requires_npm = false,
					requires_generate_from_grammar = false,
					location = "cfscript",
				},
				filetype = "cfscript",
			}

			-- Register CFHTML parser (for .cfm and .cfml files - HTML/CFML mixed)
			parser_config.cfhtml = {
				install_info = {
					url = "https://github.com/cfmleditor/tree-sitter-cfml",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
					generate_requires_npm = false,
					requires_generate_from_grammar = false,
					location = "cfhtml",
				},
				filetype = "cfhtml",
			}

			require("nvim-treesitter.configs").setup({
				ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"typescript",
				"tsx",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = { "ruby" } },
			indent = { enable = true, disable = { "ruby" } },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			textobjects = {
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
						-- ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
					},
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "<c-v>",
					},
				include_surrounding_whitespace = true,
			},
		},
	})
		end,
	},
}
