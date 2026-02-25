return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local mason_lspconfig = require("mason-lspconfig")
		local lspconfig = require("lspconfig")

		---@param server_name string
		---@return table|nil
		local function load_server_config(server_name)
			local ok, config = pcall(require, "plugins.lsp.servers." .. server_name)
			if ok then
				return config
			end
			return nil
		end

		mason_lspconfig.setup({
			ensure_installed = {
				-- Web Development
				"html", -- HTML
				"cssls", -- CSS
				"ts_ls", -- TypeScript/JavaScript

				-- Vue.js
				"vue_ls", -- Vue 3 (Volar) - for Nuxt 3 and Vue 3 projects

				-- Backend & Templating
				"intelephense", -- PHP
				"twiggy_language_server", -- Twig

				-- System Programming
				"gopls", -- Go
				"lua_ls", -- Lua (for Neovim config)

				-- Configuration Files
				"jsonls", -- JSON
				"yamlls", -- YAML
				"bashls", -- Bash
				"dockerls", -- Dockerfile
				"sqlls", -- SQL
			},
			automatic_installation = { exclude = {} },
			handlers = {
				-- Default handler: setup all servers with base config
				function(server_name)
					local base_config = _G.lsp_base_config or {}
					local server_config = load_server_config(server_name) or {}

					-- Merge base config with server-specific config
					local final_config = vim.tbl_deep_extend("force", base_config, server_config)

					lspconfig[server_name].setup(final_config)
				end,
			},
		})
	end,
}
