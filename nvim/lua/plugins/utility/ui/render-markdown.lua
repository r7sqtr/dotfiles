return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	ft = {
		"markdown",
		"markdown.mdx",
		"codecompanion",
	},
	opts = {
		file_types = {
			"markdown",
			"codecompanion",
		},
	},
}
