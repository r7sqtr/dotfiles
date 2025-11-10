-- CSS Language Server
return {
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore", -- Ignore unknown @ rules (e.g., Tailwind directives)
			},
		},
		scss = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		less = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by prettier via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
