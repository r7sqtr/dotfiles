-- Twig Language Server
return {
	filetypes = { "twig" },
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by twig-cs-fixer via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
