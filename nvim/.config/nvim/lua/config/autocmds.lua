vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	callback = function()
		if vim.fn.mode() ~= "c" then vim.cmd("checktime") end
	end,
	pattern = "*",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	callback = function()
		vim.notify("File changed on disk, buffer reloaded", vim.log.levels.WARN)
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

-- Silently ignore swap files when LSP (or anything else) opens a buffer programmatically
vim.api.nvim_create_autocmd("SwapExists", {
	callback = function() vim.v.swapchoice = "e" end,
})
