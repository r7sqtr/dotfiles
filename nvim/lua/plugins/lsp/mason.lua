return {
	-- LSP Installer and Management
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason Conform for Formatting
	{
		"zapling/mason-conform.nvim",
		config = function()
			require("mason-conform").setup({
				ensure_installed = {
					"djlint",
					"gofumpt",
					"kulala-fmt",
					"php-cs-fixer",
					"prettierd",
					"prettier",
					"shfmt",
					"stylua",
					"sql-formatter",
					"blade-formatter",
          "twig-cs-fixer",
				},
				automatic_installation = true,
        formatter_by_ft = {
          html = { "djlint" },
          twig = { "twig-cs-fixer" },
          blade = { "blade-formatter" },
          php = { "php-cs-fixer" },
          go = { "gofumpt" },
        }
			})
		end,
	},

	-- Linting and Formatting
	{
		"rshkarin/mason-nvim-lint",
		config = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			require("mason-nvim-lint").setup({
				ignore_install = {
					"sqruff",
					"zsh",
					"commitlint", -- mason registered but not by this plugin
				},
				automatic_installation = true,
			})
		end,
	},

	-- LSP Config and Automatic Installation
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "neovim/nvim-lspconfig" },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")

			mason.setup()
			mason_lspconfig.setup({
				ensure_installed = {
					"html", -- HTML
					"cssls", -- CSS
					"vuels", -- Vue (Vetur) ※Nuxt2想定。Nuxt3等はvolar
					"twiggy_language_server", -- Twig
					"ts_ls", -- TypeScript/JavaScript（旧tsserver）
					"intelephense", -- PHP
					"gopls", -- Go
					"lua_ls", -- Lua
					"sqlls", -- SQL
					"jsonls", -- JSON
					"bashls", -- Bash
					"yamlls", -- YAML
					"dockerls", -- Dockerfile
					"stimulus_ls", -- Stimulus
				},
				automatic_installation = { exclude = {} },
			})
		end,
	},
}
