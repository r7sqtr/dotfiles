return {
	"folke/sidekick.nvim",
	enabled = true,
	cmd = { "Sidekick" },
	---@class sidekick.Config
	opts = {
		nes = { enabled = false },
		cli = {
			mux = {
				enabled = false,
			},
		},
	},
	keys = {
		{
			"<leader>ac",
			function()
				require("sidekick.cli").toggle()
			end,
			desc = "Sidekick Toggle CLI",
		},
		{
			"<leader>af",
			function()
				require("sidekick.cli").send({ msg = "{file}" })
			end,
			desc = "Send File",
		},
		{
			"<leader>av",
			function()
				require("sidekick.cli").send({ msg = "{selection}" })
			end,
			mode = { "x" },
			desc = "Send Visual Selection",
		},
		{
			"<leader>ap",
			function()
				require("sidekick.cli").prompt()
			end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
		-- Example of a keybinding to open Claude directly
		{
			"<leader>aa",
			function()
				require("sidekick.cli").toggle({ name = "claude", focus = true })
			end,
			desc = "Sidekick Toggle Claude",
		},
	},
}
