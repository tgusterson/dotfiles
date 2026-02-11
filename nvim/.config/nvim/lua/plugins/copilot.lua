return {
	"github/copilot.vim",
	config = function()
		vim.g.copilot_no_tab_map = true
		vim.keymap.set("i", "<C-a>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false, desc = "Copilot accept" })
		vim.keymap.set("i", "<C-l>", 'copilot#AcceptLine("\\<CR>")', { expr = true, replace_keycodes = false, desc = "Copilot accept line" })
	end,
}
