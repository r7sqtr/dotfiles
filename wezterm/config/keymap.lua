local wezterm = require("wezterm")
local act = wezterm.action
local colorscheme = require("config.colorscheme")

local keymap = {}

function keymap.setup(config)
	-- Key bindings configuration
	config.keys = {
		-- Send newline with Shift+Enter
		{
			key = "Enter",
			mods = "SHIFT",
			action = act.SendString("\n"),
		},

		-- Color scheme picker (CMD+SHIFT+P)
		{
			key = "p",
			mods = "CMD|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				wezterm.log_info("Launching color scheme picker")
				colorscheme.pick(window, pane)
			end),
		},
	}
end

return keymap
