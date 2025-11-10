-- SQL Language Server
return {
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by sql-formatter via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
