-- Bash Language Server
return {
	filetypes = { "sh", "bash", "zsh" },
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by shfmt via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
