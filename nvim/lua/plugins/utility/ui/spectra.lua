return {
	"r7sqtr/spectra.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	event = "VimEnter", -- Load early to restore persisted colorscheme
	cmd = "Spectra",
	keys = {
		{ "<leader>sp", "<cmd>Spectra<cr>", desc = "Open Colorscheme Picker" },
	},
	opts = {
		themes = {
			"ayu",
			"everforest",
			"catppuccin",
			"tokyonight",
			"gruvbox",
			"nord",
			"onedark",
			"solarized-osaka",
			"kanagawa",
			"palenight",
			"monokai-pro",
		},
		width = 50,
		height = 15,
		border = "rounded",
		live_preview = true,
		persist = true,
	},
}
