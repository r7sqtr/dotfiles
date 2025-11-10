return {
	"stevearc/conform.nvim",
	opts = {
		formatters = {
			["php-cs-fixer"] = {
				command = vim.fn.expand("~/.local/share/nvim/mason/bin/php-cs-fixer"),
				args = {
					"fix",
					"--no-interaction",
					"--quiet",
					"--using-cache=no", -- キャッシュ無効化
					"$FILENAME",
				},
				stdin = false,
			},
		},
		formatters_by_ft = {
			bash = {
				"beautysh",
				"shfmt",
				"shellharden",
			},
			html = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			css = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			javascript = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			javascriptreact = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			json = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			jsonc = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			less = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			lua = { "stylua" },
			scss = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			sh = { "beautysh", "shfmt" },
			typescript = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			typescriptreact = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			vue = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			yaml = {
				"prettierd",
				"prettier",
				stop_after_first = true,
			},
			zsh = { "beautysh", "shfmt" },
			php = { "php-cs-fixer" },
			sql = { "sql-formatter" },
			blade = { "blade-formatter" },
			go = { "gofumpt" },
		},
	},
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					async = true,
				})
			end,
			desc = "Format",
		},
	},
}
