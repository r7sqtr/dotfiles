-- Lua Language Server (lua_ls)
-- Optimized for Neovim configuration development
return {
	settings = {
		Lua = {
			-- Runtime
			runtime = {
				version = "LuaJIT",
			},
			-- Diagnostics
			diagnostics = {
				globals = { "vim" }, -- Recognize 'vim' as global
			},
			-- Workspace
			workspace = {
				checkThirdParty = false, -- Don't ask about third-party libraries
				library = {
					vim.env.VIMRUNTIME,
					-- Additional libraries can be added here
				},
			},
			-- Completion
			completion = {
				callSnippet = "Replace",
			},
			-- Telemetry
			telemetry = {
				enable = false,
			},
			-- Hints
			hint = {
				enable = true,
				setType = true,
				paramName = "All",
				paramType = true,
				arrayIndex = "Enable",
			},
			-- Format (disabled, handled by stylua via conform.nvim)
			format = {
				enable = false,
			},
		},
	},
	on_attach = function(client, bufnr)
		-- Disable formatting (handled by stylua via conform.nvim)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
}
