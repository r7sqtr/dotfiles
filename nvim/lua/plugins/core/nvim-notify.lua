return {
	"rcarriga/nvim-notify",
	opts = {
		background_colour = "#1e1e2e",
		timeout = 1000,
	},
	config = function(_, opts)
		require("notify").setup(opts)
	end,
}
