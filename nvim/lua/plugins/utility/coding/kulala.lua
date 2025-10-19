return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	opts = {
		global_keymaps = false,
		global_keymaps_prefix = "<leader>R",
    default_env = "local",
	},
	keys = {
		{ "<leader>r", "", desc = "+Rest", ft = "http" },
		{ "<leader>rs", "<cmd>lua require('kulala').run()<cr>", desc = "Send Request" },
		{ "<leader>ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "Sent All Request" },
		{ "<leader>rb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open Scratch Pad" },
		{ "<leader>rt", "<cmd>lua require('kulala').toggle_view()<cr>", desc = "Toggle View" },
		{ "<leader>re", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "Set Select ENV" },
	},
}
