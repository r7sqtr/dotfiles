return {
	"zaldih/themery.nvim",
	lazy = false,
	priority = 1000,
	cmd = "Themery",
	event = "VimEnter",
	opts = function()
		return {
      -- stylua: ignore
      themes = {
        "ayu",
        "catppuccin",
        "everforest",
        "kanagawa",
        "night-owl",
        "nord",
        "nordic",
        "onedark",
        "solarized-osaka",
        "tokyonight",
        "palenight",
        "everblush",
      },
		}
	end,
}
