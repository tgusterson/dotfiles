-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })

-- Command mode
vim.keymap.set("n", "<leader>;", ":", { noremap = true, desc = "Command mode" })

-- Copy current file path
vim.keymap.set("n", "<leader>cp", ':let @+ = expand("%:p") | echo "Copied: " . @+<CR>', { noremap = true, desc = "Copy file path" })

-- Jump out of autopaired characters
vim.keymap.set("i", "<C-j>", "<Esc>la", { noremap = true, silent = true })

-- Quickfix
vim.keymap.set("n", "<leader>z", vim.cmd.cclose, { noremap = true, silent = true, desc = "Close quickfix" })
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { noremap = true, silent = true, desc = "Next quickfix" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { noremap = true, silent = true, desc = "Prev quickfix" })

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Re-source config
vim.keymap.set("n", "<leader>vv", "<cmd>source $MYVIMRC<CR>", { noremap = true, desc = "Source config" })

-- Window navigation (overridden by tmux-navigator plugin when in tmux)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Upper window" })

-- Terminal escape
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Copilot (set here so they're available before plugins load)
vim.keymap.set("i", "<C-a>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.keymap.set("i", "<C-l>", 'copilot#AcceptLine("\\<CR>")', { expr = true, replace_keycodes = false })
