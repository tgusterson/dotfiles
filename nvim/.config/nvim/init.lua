-- ** Keymaps & options available in Neovim and VSCode **
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>;", ":", { noremap = true, desc = "Command mode" })
vim.keymap.set("n", "<shift>:", ";", { noremap = true })

-- Leave insert mode, oress l, press a. I use this as an easy way to jump out of autopaired characters.
-- Could look into different autopairing plugin which offers this feature but this is good enough for now.
vim.keymap.set("i", "<C-j>", "<Esc>la", { noremap = true, silent = true })

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { noremap = true, silent = true, desc = "Next quickfix" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { noremap = true, silent = true, desc = "Previous quickfix" })

-- Press <leader>z to close the quickfix window
vim.keymap.set("n", "<leader>z", vim.cmd.cclose, { noremap = true, silent = true, desc = "Close quickfix" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

if vim.fn.exists("g:vscode") == 1 then
	print("Running in VSCode...")
else
	-- ** Keymaps & options available in Neovim only **
	-- Set <space> as the leader key
	-- See `:help mapleader`
	--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
	vim.opt.shiftwidth = 2
	vim.opt.tabstop = 2
	vim.opt.softtabstop = 2
	vim.opt.expandtab = true

	-- Set to true if you have a Nerd Font installed and selected in the terminal
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

	-- Enable mouse mode, can be useful for resizing splits for example!
	vim.opt.mouse = "a"

	-- Sync clipboard between OS and Neovim.
	--  Schedule the setting after `UiEnter` because it can increase startup-time.
	--  Remove this option if you want your OS clipboard to remain independent.
	--  See `:help 'clipboard'`
	-- end)

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

	-- [[ Basic Keymaps ]]
	--  See `:help vim.keymap.set()`

	vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true })
	vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

	-- vim.keymap.set("n", ";", ":", { noremap = true })
	-- Clear highlights on search when pressing <Esc> in normal mode
	--  See `:help hlsearch`
	vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

	-- Diagnostic keymaps
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

	-- TIP: Disable arrow keys in normal mode
	vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
	vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
	vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
	vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

	-- Keybinds to make split navigation easier.
	--  Use CTRL+<hjkl> to switch between windows
	--
	--  See `:help wincmd` for a list of all window commands
	vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
	vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
	vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
	vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

	vim.keymap.set("n", "<leader>\\", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
	vim.keymap.set("n", "\\", "<CMD>Neotree toggle<CR>", { desc = "Open file tree" })

	vim.keymap.set("i", "<C-a>", 'copilot#Accept("\\<CR>")', {
		expr = true,
		replace_keycodes = false,
	})
	vim.g.copilot_no_tab_map = true

	-- [[ Basic Autocommands ]]
	--  See `:help lua-guide-autocommands`

	require("config.lazy")
end
