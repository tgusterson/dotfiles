local tools = require("config.tools")

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufWritePost", "InsertLeave" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = tools.linters
		vim.list_extend(lint.linters.luacheck.args, { "--globals", "vim" })

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			callback = function() lint.try_lint() end,
		})
	end,
}
