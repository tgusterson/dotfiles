return {
	{
		"stevearc/conform.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fb",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				desc = "[F]ormat [b]uffer",
			},
		},
		opts = {
			notify_on_error = false,

			formatters = {
				prettier = {
					require_cwd = true,
				},
			},
			format_on_save = function(bufnr)
				local disable = { c = true, cpp = true }
				local lsp_fmt = disable[vim.bo[bufnr].filetype] and "never" or "fallback"
				return {
					timeout_ms = 500,
					lsp_format = lsp_fmt,
				}
			end,
		},
	},
}
