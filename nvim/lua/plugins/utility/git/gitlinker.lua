return {
	"linrongbin16/gitlinker.nvim",
	cmd = "GitLink",
	config = function()
		require("gitlinker").setup()
	end,
	keys = {
		{ "<Leader>gl", "<cmd>GitLink<CR>", mode = { "n", "v", "x" }, desc = "Yank Git Link" },
		{
			"<leader>go",
			"<cmd>GitLink!<cr>",
			mode = { "n", "v", "x" },
			desc = "Open in browser",
		},
	},
}
