-- Set <space> as the leader key
-- NOTE: Must happen before plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Options ]]
vim.o.autoread = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.g.have_nerd_font = true
vim.opt.path:append { "**" }

-- Undecided on this:
-- vim.opt.wildmenu = true
-- vim.opt.wildmode = 'longest,list,full'

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = false,
})

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk, buffer reloaded", vim.log.levels.WARN)
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>;", ":", { noremap = true, desc = "Command mode" })
vim.keymap.set("n", "<leader>cp", ':let @+ = expand("%:p") | echo "Copied: " . @+<CR>', { noremap = true, desc = "Copy file path" })
vim.keymap.set("i", "<C-j>", "<Esc>la", { noremap = true, silent = true, desc = "Jump past autopair" })
-- vim.keymap.set("n", "<leader>z", vim.cmd.cclose, { noremap = true, silent = true, desc = "Close quickfix" })
-- vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { noremap = true, silent = true, desc = "Next quickfix" })
-- vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { noremap = true, silent = true, desc = "Prev quickfix" })

require("config.lazy")
