return {
	"bassamsdata/namu.nvim",
	event = { "BufRead" },
	config = function()
		require("namu").setup({
			-- Enable the modules you want
			namu_symbols = {
				enable = true,
				options = {
					AllowKinds = {
						default = {
							"Method",
						},
					},
				},
			},
			window = {
				auto_size = true,
				min_height = 1,
				min_width = 20,
				max_width = 120,
				max_height = 30,
				padding = 2,
				border = "rounded",
				title_pos = "left",
				show_footer = true,
				footer_pos = "right",
				relative = "editor",
				style = "minimal",
				width_ratio = 0.6,
				height_ratio = 0.6,
				title_prefix = "󱠦 ",
			},
			row_position = "top10_right",
			-- Optional: Enable other modules if needed
			ui_select = { enable = false }, -- vim.ui.select() wrapper
			colorscheme = {
				enable = true,
				options = {
					persist = true, -- very efficient mechanism to Remember selected colorscheme
					write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
				},
			},
		})
		vim.keymap.set("n", "<leader>t", ":Namu symbols<cr>", {
			desc = "+Symbol",
			silent = true,
		})
	end,
}
