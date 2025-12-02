-- Vue 3 Language Server (Volar)
-- Official Vue 3 LSP with Takeover Mode support
return {
	filetypes = { "vue" },
	init_options = {
		typescript = {
			-- Path to TypeScript SDK (optional, usually auto-detected)
			tsdk = "",
		},
		vue = {
			hybridMode = false, -- Set to true if using both Volar and ts_ls
		},
	},
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by Prettier via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
