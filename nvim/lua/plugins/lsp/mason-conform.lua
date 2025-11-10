return {
	"zapling/mason-conform.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"stevearc/conform.nvim",
	},
	config = function()
		require("mason-conform").setup({
			ensure_installed = {
				"djlint", -- HTML
				"gofumpt", -- Go
				"kulala-fmt", -- Kulala REST client
				"php-cs-fixer", -- PHP
				"prettierd", -- Multi-language (faster than prettier)
				"prettier", -- Multi-language (fallback)
				"shfmt", -- Shell script
				"stylua", -- Lua
				"sql-formatter", -- SQL
				"blade-formatter", -- Laravel Blade
				"twig-cs-fixer", -- Twig
			},
			automatic_installation = true,
		})
	end,
}
