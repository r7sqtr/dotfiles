return {
	"Shatur/neovim-ayu",
	lazy = true,
	priority = 1000,
	config = function()
		require("ayu").setup({
			mirage = true,
		})
	end,
}
