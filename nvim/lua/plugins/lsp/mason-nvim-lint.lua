return {
	"rshkarin/mason-nvim-lint",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-lint",
	},
	config = function()
		-- Set formatexpr to use conform.nvim
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		require("mason-nvim-lint").setup({
			ensure_installed = {},
			ignore_install = {
				"sqruff",
				"zsh",
				"commitlint", -- Registered in mason but not by this plugin
			},
			automatic_installation = true,
		})
	end,
}
