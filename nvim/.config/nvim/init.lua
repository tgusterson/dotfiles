vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.g.copilot_no_tab_map = true

require("config.options")
require("config.keymaps")
require("config.autocmds")

if vim.fn.exists("g:vscode") == 0 then
	require("config.lazy")
end
