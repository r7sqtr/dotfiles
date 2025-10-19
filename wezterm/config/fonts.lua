local wezterm = require("wezterm")
local Fonts = {}

function Fonts.setup(config)
	config.font = wezterm.font("PlemolJP Console NF")
	config.font_size = 16.5
	config.line_height = 1.2
	config.use_ime = true
end

return Fonts
