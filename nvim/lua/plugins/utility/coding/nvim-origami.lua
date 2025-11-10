return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {
		foldtext = {
			enabled = true,
			padding = 3,
			lineCount = {
				template = "󰘖 %d", -- `%d` is replaced with the number of folded lines
				hlgroup = "Comment",
			},
			diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
			gitsignsCount = true, -- requires `gitsigns.nvim`
		},
	},

	init = function()
		-- When folding is enabled, start with all folds open
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		-- Use manual or marker-based folding instead of automatic
		vim.opt.foldmethod = "manual"
	end,
}
