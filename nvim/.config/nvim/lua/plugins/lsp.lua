local tools = require("config.tools")

return {
	{ "williamboman/mason.nvim", opts = {} },

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
		opts = {
			ensure_installed = tools.lsp_list,
			automatic_enable = true,
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = tools.tools_list,
			auto_update = true,
			run_on_start = true,
			start_delay = 3000,
			debounce_hours = 5,
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp", "williamboman/mason-lspconfig.nvim" },
		config = function()
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local buf = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then return end

					local map = function(lhs, rhs, desc, mode)
						vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc })
					end

					-- Capability-gated keymaps
					local caps = client.server_capabilities
					if caps.definitionProvider then
						map("gd", vim.lsp.buf.definition, "Go to Definition")
					end
					if caps.referencesProvider then
						map("gr", vim.lsp.buf.references, "Go to References")
					end
					if caps.hoverProvider then
						map("K", vim.lsp.buf.hover, "Hover Documentation")
					end
					if caps.implementationProvider then
						map("gi", vim.lsp.buf.implementation, "Go to Implementation")
					end
					if caps.declarationProvider then
						map("gD", vim.lsp.buf.declaration, "Go to Declaration")
					end
					if caps.signatureHelpProvider then
						map("<leader>h", vim.lsp.buf.signature_help, "Signature Help")
					end
					if caps.renameProvider then
						map("<leader>r", vim.lsp.buf.rename, "Rename Symbol")
					end
					if caps.codeActionProvider then
						map("<leader>c", vim.lsp.buf.code_action, "Code Action")
					end

					-- Diagnostics are always available
					map("<leader>q", vim.diagnostic.setqflist, "Diagnostics → Quickfix")
					map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")
					map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev Diagnostic")
					map("<leader>e", function()
						local _, winnr = vim.diagnostic.open_float()
						if winnr then vim.api.nvim_set_current_win(winnr) end
					end, "Show Diagnostic")
				end,
			})

			vim.lsp.config("lua_ls", {
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

			-- biome requires utf-16 offset encoding
			vim.lsp.config("biome", {
				on_init = function(client)
					client.offset_encoding = "utf-16"
				end,
			})

			-- ts_ls: root_markers finds nearest dir containing any of these (order = priority)
			vim.lsp.config("ts_ls", {
				root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
				init_options = {
					preferences = { includePackageJsonAutoImports = "off" },
				},
			})

			-- ColdFusion
			vim.filetype.add({ extension = { cfc = "cfc", cfm = "cfm", cfml = "cfm" } })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "cfc",
				callback = function() vim.bo.commentstring = "// %s" end,
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "cfm",
				callback = function() vim.bo.commentstring = "<!--- %s --->" end,
			})
			vim.lsp.config("coldfusion_lsp", {
				cmd = { "node", vim.fn.expand("~/other-repos/coldfusion-lsp/out/server.js"), "--stdio" },
				filetypes = { "cfc", "cfm" },
				root_markers = { ".git", "Application.cfc" },
			})
			vim.lsp.enable("coldfusion_lsp")
		end,
	},
}
