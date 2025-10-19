return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("trouble").setup({
			modes = {
				diagnostics = {
					auto_open = false,
					auto_close = true,
				},
			},
			warn_no_results = false,
		})
	end,
	keys = {
		{
			"<leader>yt",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "trouble diagnostics",
		},
		{
			"<leader>yT",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "buffer diagnostics",
		},
	},
}
