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

		-- Split pane vertically (CMD+D)
		{
			key = "d",
			mods = "CMD",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},

		-- Split pane horizontally (CMD+SHIFT+D)
		{
			key = "d",
			mods = "CMD|SHIFT",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},

		-- Close current pane (CMD+W)
		{
			key = "w",
			mods = "CMD",
			action = act.CloseCurrentPane({ confirm = true }),
		},

		-- Navigate between panes (CMD+Arrow keys)
		{
			key = "LeftArrow",
			mods = "CMD",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "RightArrow",
			mods = "CMD",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "UpArrow",
			mods = "CMD",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "DownArrow",
			mods = "CMD",
			action = act.ActivatePaneDirection("Down"),
		},
	}
end

return keymap
