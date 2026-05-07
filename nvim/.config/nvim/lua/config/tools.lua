local M = {}

M.lsp = {
	lua_ls = {},
	biome = {},
	jsonls = {},
	ts_ls = {},
	tailwindcss = {},
	marksman = {},
	pyright = {},
	sqlls = {},
	gopls = {},
	clangd = {},
}

M.linters = {
	python = { "flake8" },
	html = { "htmlhint" },
	lua = { "luacheck" },
	go = { "golangcilint" },
}

-- Maps nvim-lint tool names → Mason package names where they differ
M.mason_name_map = {
	golangcilint = "golangci-lint",
}

M.formatters = {
	python = { "pyink" },
	lua = { "stylua" },
	html = { "prettierd", "biome" },
	javascript = { "prettierd", "biome" },
	typescript = { "prettierd", "biome" },
	typescriptreact = { "prettierd", "biome" },
	javascriptreact = { "prettierd", "biome" },
	graphql = { "biome" },
	sql = { "sql-formatter" },
	go = { "goimports" },
	c = { "clang-format" },
}

local function extract_lsp_servers(t)
	local servers = {}
	for server in pairs(t) do table.insert(servers, server) end
	return servers
end

local function extract_unique_tools(t, name_map)
	local tools, seen = {}, {}
	for _, list in pairs(t) do
		for _, tool in ipairs(list) do
			local name = (name_map and name_map[tool]) or tool
			if not seen[name] then
				table.insert(tools, name)
				seen[name] = true
			end
		end
	end
	return tools
end

M.lsp_list = extract_lsp_servers(M.lsp)
M.linters_list = extract_unique_tools(M.linters, M.mason_name_map)
M.formatters_list = extract_unique_tools(M.formatters)

local seen = {}
M.tools_list = {}
for _, list in ipairs({ M.linters_list, M.formatters_list }) do
	for _, tool in ipairs(list) do
		if not seen[tool] then
			table.insert(M.tools_list, tool)
			seen[tool] = true
		end
	end
end

return M
