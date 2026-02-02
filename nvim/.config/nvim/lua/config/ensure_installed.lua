local M = {}

-- Define LSPs, linters, and formatters
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
}

M.linters = {
	python = { "flake8" },
	markdown = { "markdownlint" },
	html = { "htmlhint" },
	lua = { "luacheck" },
	go = { "golangci-lint" },
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
}

function M.extract_lsp_servers(lsp_table)
	local servers = {}
	for server, _ in pairs(lsp_table) do
		table.insert(servers, server)
	end
	return servers
end

function M.extract_unique_tools(tool_table)
	local unique_tools = {}
	local seen = {}

	for _, tools in pairs(tool_table) do
		for _, tool in ipairs(tools) do
			if not seen[tool] then
				table.insert(unique_tools, tool)
				seen[tool] = true
			end
		end
	end

	return unique_tools
end

M.lsp_list = M.extract_lsp_servers(M.lsp)
M.linters_list = M.extract_unique_tools(M.linters)
M.formatters_list = M.extract_unique_tools(M.formatters)

local function merge_tool_lists(list1, list2)
	local merged = {}
	local seen = {}

	for _, tool in ipairs(list1) do
		if not seen[tool] then
			table.insert(merged, tool)
			seen[tool] = true
		end
	end

	for _, tool in ipairs(list2) do
		if not seen[tool] then
			table.insert(merged, tool)
			seen[tool] = true
		end
	end

	return merged
end

M.tools_list = merge_tool_lists(M.linters_list, M.formatters_list)

return M
