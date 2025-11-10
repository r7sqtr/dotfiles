return {
	"mason-org/mason.nvim",
	cmd = "Mason",
	build = ":MasonUpdate", -- Automatically update registry
	config = function()
		require("mason").setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			max_concurrent_installers = 10,
		})
	end,
}
