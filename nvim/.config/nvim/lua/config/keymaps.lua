-- Copy to clipboard
vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- Quick command mode
vim.keymap.set("n", "<leader>;", ":", { noremap = true, desc = "Command mode" })
vim.keymap.set("n", "<shift>:", ";", { noremap = true })

-- Copy file path
vim.keymap.set(
	"n",
	"<leader>cp",
	':let @+ = expand("%:p") | echo "Copied: " . @+<CR>',
	{ noremap = true, desc = "Copy file path" }
)

-- Leave insert mode and move right — easy way to jump out of autopaired characters
vim.keymap.set("i", "<C-j>", "<Esc>la", { noremap = true, silent = true })

-- Quickfix
vim.keymap.set("n", "<leader>z", vim.cmd.cclose, { noremap = true, silent = true, desc = "Close quickfix" })
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { noremap = true, silent = true, desc = "Next quickfix" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { noremap = true, silent = true, desc = "Previous quickfix" })

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
