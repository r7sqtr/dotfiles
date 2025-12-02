return {
	"sindrets/diffview.nvim",
	lazy = true,
	enabled = true,
	event = "BufReadPost",
	keys = {
		{ "<Leader>gS", "<Cmd>DiffviewFileHistory<CR>", desc = "diff file" },
		{ "<Leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "status" },
	},
}
