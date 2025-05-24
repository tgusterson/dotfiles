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
        automatic_installation = true,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed.tools_list,
        -- auto_update = true,
        -- run_on_start = true,
        -- start_delay = 3000,
        -- debounce_hours = 5,
        integrations = {
          ["mason-lspconfig"] = true,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      servers = ensure_installed.lsp,
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")

      local function on_attach(_, bufnr)
        -- Set buffer-local options
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Define a reusable keymap helper
        local keymap_opts = { noremap = true, silent = true, buffer = bufnr }
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", keymap_opts, { desc = desc }))
        end

        -- LSP-related keymaps
        ----------------------------------------------------------------------------
        -- Jump to definition
        map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
        -- Show hover information
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        -- List implementations
        map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
        -- Show references
        -- map("n", "gr", vim.lsp.buf.references, "Find References")
        map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        -- See available code actions
        map("n", "<leader>c", vim.lsp.buf.code_action, "Code Action")
        -- Rename symbol under cursor
        map("n", "<leader>r", vim.lsp.buf.rename, "Rename Symbol")
        -- Go to declaration
        map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
        -- Signature help (function signature while typing)
        map("n", "<leader>h", vim.lsp.buf.signature_help, "Signature Help")

        -- Diagnostic-related keymaps
        ----------------------------------------------------------------------------
        -- Go to next/previous diagnostic
        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        -- Open a floating window with diagnostic info
        map("n", "<leader>e", vim.diagnostic.open_float, "Show Diagnostic")
        -- Show all diagnostics (by default, for the current workspace)
        map("n", "<leader>q", vim.diagnostic.setloclist, "Populate Loclist with Diagnostics")
      end

      -- Setup each server with our on_attach and blink.cmp capabilities
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
    end,
  },
}
