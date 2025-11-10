-- Vue 2 Language Server (Vetur/VLS)
-- For legacy Vue 2 and Nuxt 2 projects
return {
	filetypes = { "vue" },
	init_options = {
		config = {
			vetur = {
				useWorkspaceDependencies = true,
				validation = {
					template = true,
					style = true,
					script = true,
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by Prettier via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
