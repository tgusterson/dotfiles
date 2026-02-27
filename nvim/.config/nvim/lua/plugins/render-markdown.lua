return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	ft = { "markdown" },
	opts = {},
	config = function(_, opts)
		require("render-markdown").setup(opts)
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*/ref-markdown.md",
			callback = function()
				vim.cmd("RenderMarkdown disable")
			end,
		})
		vim.api.nvim_create_autocmd("BufLeave", {
			pattern = "*/ref-markdown.md",
			callback = function()
				vim.cmd("RenderMarkdown enable")
			end,
		})
	end,
}
