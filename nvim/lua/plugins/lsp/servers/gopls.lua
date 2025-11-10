-- Go Language Server (gopls)
-- Official Go LSP with comprehensive analysis and optimization
return {
	settings = {
		gopls = {
			-- Analysis
			analyses = {
				unusedparams = true,
				unusedwrite = true,
				unusedvariable = true,
				shadow = true,
			},
			-- Code Lenses
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			-- Completion
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = {
				"-**/node_modules",
				"-**/vendor",
			},
			-- Hints
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			-- Semantic Tokens
			semanticTokens = true,
		},
	},
	on_attach = function(client, bufnr)
		-- Formatting is handled by gofumpt via conform.nvim (see lua/plugins/lsp/lang/go.lua)
		-- But gopls formatting can remain enabled as a fallback
	end,
}
