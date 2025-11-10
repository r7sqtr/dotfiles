-- YAML Language Server
return {
	settings = {
		yaml = {
			schemas = require("schemastore").yaml.schemas(),
			validate = true,
			hover = true,
			completion = true,
			format = {
				enable = false, -- Handled by prettier via conform.nvim
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by prettier via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
