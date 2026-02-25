return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		spec = {
			{ "<leader>a", group = "+Sidekick", mode = { "n", "v" } },
			{ "<leader>c", group = "+CodeCompanion", mode = { "n", "v" } },
			{ "<leader>f", group = "+Snacks", mode = { "n", "v" } },
			{ "<leader>g", group = "+Git", mode = { "n", "v" } },
			{ "<leader>l", group = "+Lazy", mode = { "n", "v" } },
			{ "<leader>m", group = "+Noxen", mode = { "n", "v" } },
			{ "<leader>p", group = "+PHP", mode = { "n", "v" } },
			{ "<leader>r", group = "+Kulala", mode = { "n", "v" } },
			{ "<leader>s", group = "+Spectra", mode = { "n", "v" } },
			{ "<leader>x", group = "+Trouble", mode = { "n", "v" } },
			{ "<leader>z", group = "+Zen", mode = { "n", "v" } },
		},
		triggers = {
			{ "<leader>", mode = { "n", "v" } },
		},
	},
	keys = {
		{
			"<leader>v",
			function()
				vim.cmd("!code %")
			end,
			desc = "Open in VSCode",
		},
		{
			"<leader>uL",
			function()
				local config = vim.diagnostic.config()
				vim.diagnostic.config({
					virtual_lines = not config.virtual_lines,
					virtual_text = config.virtual_lines, -- 片方をトグル
				})
			end,
			desc = "Toggle lsp_lines",
		},
	},
}
