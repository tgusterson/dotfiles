-- ** Keymaps & options available in Neovim and VSCode **

vim.o.autoread = true

-- Check for external changes
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
	pattern = { "*" },
})

-- Show notification when file is reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk, buffer reloaded", vim.log.levels.WARN)
	end,
})

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = false,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

require("config.keymaps")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

if vim.fn.exists("g:vscode") == 1 then
	print("Running in VSCode...")
else
	-- ** Keymaps & options available in Neovim only **
	vim.opt.shiftwidth = 2
	vim.opt.tabstop = 2
	vim.opt.softtabstop = 2
	vim.opt.expandtab = true
	vim.g.have_nerd_font = true

	-- [[ Setting options ]]
	-- See `:help vim.opt`
	-- NOTE: You can change these options as you wish!
	--  For more options, you can see `:help option-list`

	-- Make line numbers default
	vim.opt.number = true
	-- You can also add relative line numbers, to help with jumping.
	--  Experiment for yourself to see if you like it!
	vim.opt.relativenumber = true
	vim.opt.showmode = false

	-- Enable mouse mode, can be useful for resizing splits
	vim.opt.mouse = "a"

	-- Enable break indent
	vim.opt.breakindent = true

	-- Save undo history
	vim.opt.undofile = true

	-- Keep signcolumn on by default
	vim.opt.signcolumn = "yes"

	-- Decrease update time
	vim.opt.updatetime = 250

	-- Decrease mapped sequence wait time
	vim.opt.timeoutlen = 300

	-- Configure how new splits should be opened
	vim.opt.splitright = true
	vim.opt.splitbelow = true

	-- Sets how neovim will display certain whitespace characters in the editor.
	--  See `:help 'list'`
	--  and `:help 'listchars'`
	vim.opt.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

	-- Preview substitutions live, as you type!
	vim.opt.inccommand = "split"

	-- Show which line your cursor is on
	vim.opt.cursorline = true

	-- Minimal number of screen lines to keep above and below the cursor.
	vim.opt.scrolloff = 10

	vim.keymap.set("n", "\\", "<CMD>Neotree toggle<CR>", { desc = "Open file tree" })
	vim.keymap.set("i", "<C-a>", 'copilot#Accept("\\<CR>")', {
		expr = true,
		replace_keycodes = false,
	})
	vim.keymap.set("i", "<C-l>", 'copilot#AcceptLine("\\<CR>")', {
		expr = true,
		replace_keycodes = false,
	})
	vim.g.copilot_no_tab_map = true

	require("config.lazy")
end
