return {
	"akinsho/bufferline.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
		{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		{ "<A-,>", "<Cmd>BufferLineMovePrev<CR>", mode = "n", desc = "Move tab to Left" },
		{ "<A-.>", "<Cmd>BufferLineMoveNext<CR>", mode = "n", desc = "Move tab to Rigft" },
	},
	opts = {
		options = {
			mode = "tabs",
			show_buffer_close_icons = false,
			show_close_icon = false,
			always_show_bufferline = false,
			separator_style = "thin",
		},
	},
}
