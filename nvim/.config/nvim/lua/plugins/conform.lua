local tools = require("config.tools")

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>fb",
			function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
			mode = "",
			desc = "[F]ormat [b]uffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true }
			return {
				timeout_ms = 1000,
				lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback",
			}
		end,
		formatters_by_ft = tools.formatters,
	},
}
