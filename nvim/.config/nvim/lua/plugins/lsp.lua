local ensure_installed = require("config.ensure_installed")
return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed.lsp_list,
				automatic_enable = true,
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed.tools_list,
				auto_update = true,
				run_on_start = true,
				start_delay = 3000,
				debounce_hours = 5,
				integrations = { ["mason-lspconfig"] = true },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			local caps = require("blink.cmp").get_lsp_capabilities()
			local function on_attach(_, bufnr)
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
				local opts = { noremap = true, silent = true, buffer = bufnr }
				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
				end

				-- Key mappings
				map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
				map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
				map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
				map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("n", "<leader>c", vim.lsp.buf.code_action, "Code Action")
				map("n", "<leader>r", vim.lsp.buf.rename, "Rename Symbol")
				map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
				map("n", "<leader>h", vim.lsp.buf.signature_help, "Signature Help")
				map("n", "]d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, "Next Diagnostic")
				map("n", "[d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, "Previous Diagnostic")
				map("n", "<leader>e", vim.diagnostic.open_float, "Show Diagnostic")
				map("n", "<leader>q", vim.diagnostic.setloclist, "Populate Loclist with Diagnostics")
			end

			vim.lsp.config("*", {
				on_attach = on_attach,
				capabilities = caps,
			})

			vim.lsp.config(
				"lua_ls",
				vim.tbl_deep_extend("force", {}, vim.lsp.config["lua_ls"] or {}, {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				})
			)

			-- 4) Enable _every_ LSP server Mason has installed :contentReference[oaicite:1]{index=1}
			vim.lsp.enable(ensure_installed.lsp_list)
		end,
	},
}
