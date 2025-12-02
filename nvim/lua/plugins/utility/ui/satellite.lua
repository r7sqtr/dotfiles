return {
	"lewis6991/satellite.nvim",
	event = "VeryLazy",
	opts = {
		current_only = true,
		winblend = 10,
		handlers = {
			cursor = { enable = false },
		},
	},
	init = function()
		vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
			desc = "User: Highlights for satellite.nvim",
			callback = function()
				vim.api.nvim_set_hl(0, "SatelliteQuickfix", { link = "DiagnosticSignInfo" })
				vim.api.nvim_set_hl(0, "SatelliteMark", { link = "StandingOut" })
			end,
		})

		vim.api.nvim_create_autocmd("OptionSet", {
			desc = "User: Hide satellite.nvim scrollbar when wrapping to keep text readable",
			pattern = "wrap",
			callback = function()
				if vim.v.option_type == "global" then
					local changeTo = vim.o.wrap and "Disable" or "Enable"
					vim.cmd("Satellite" .. changeTo)
				end
			end,
		})
	end,
}
