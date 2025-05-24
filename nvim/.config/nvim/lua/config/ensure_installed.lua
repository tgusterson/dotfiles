local M = {}

-- Define LSPs, linters, and formatters
M.lsp = {
	lua_ls = {},
	eslint = {},
	jsonls = {},
	ts_ls = {},
	marksman = {},
	pyright = {},
	tailwindcss = {},
}

M.linters = {
	python = { "flake8" },
	markdown = { "markdownlint" },
	html = { "htmlhint" },
}

M.formatters = {
	python = { "pyink" },
	lua = { "stylua" },
	html = { "prettierd" },
	javascript = { "prettierd" },
	typescript = { "prettierd" },
	typescriptreact = { "prettierd" },
	javascriptreact = { "prettierd" },
	graphql = { "prettierd" },
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
