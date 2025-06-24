-- return {
-- 	"folke/ts-comments.nvim",
-- 	opts = {},
-- 	event = "VeryLazy",
-- 	enabled = vim.fn.has("nvim-0.10.0") == 1,
-- }
return {
	"numToStr/Comment.nvim",
	dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
	config = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
