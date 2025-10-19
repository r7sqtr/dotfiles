return {
	"akinsho/toggleterm.nvim",
	keys = {
		{
			"<C-t>",
			"<cmd>ToggleTerm direction=horizontal<CR>",
			desc = "Toggle Horizontal Terminal",
			mode = { "n", "t" },
		},
		{ "<C-f>", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle Float Terminal", mode = { "n", "t" } },
	},
	cmd = { "ToggleTerm", "ToggleTermOpenAll", "ToggleTermCloseAll" },
	opts = {
		size = function(term)
			if term.direction == "horizontal" then
				return 0.75 * vim.api.nvim_win_get_height(0)
			elseif term.direction == "vertical" then
				return 0.75 * vim.api.nvim_win_get_width(0)
			elseif term.direction == "float" then
				return 85
			end
		end,
		hide_numbers = true,
		shade_terminals = false,
		insert_mappings = true,
		start_in_insert = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		shell = vim.o.shell,
		autochdir = true,
		highlights = {
			NormalFloat = {
				link = "Normal",
			},
			FloatBorder = {
				link = "FloatBorder",
			},
		},
		float_opts = {
			border = "rounded",
			winblend = 0,
		},
	},
}
