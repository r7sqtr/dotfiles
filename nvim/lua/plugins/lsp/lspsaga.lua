return {
	"nvimdev/lspsaga.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lspsaga").setup({
			lightbulb = { enable = false },
			diagnostic = {
				show_code_action = true,
				show_source = true,
				virtual_text = true,
			},
		})
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
	end,
}
