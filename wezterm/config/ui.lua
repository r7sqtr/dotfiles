local wezterm = require("wezterm")
local ui = {}

function ui.setup(config)
	-- Background
	config.window_background_opacity = 0.92
	config.macos_window_background_blur = 10

	-- Window
	config.window_decorations = "RESIZE"
	config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
	config.window_frame = { inactive_titlebar_bg = "none", active_titlebar_bg = "none" }

	-- Tab bar
	config.enable_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = true
	config.tab_bar_at_bottom = true
	config.show_new_tab_button_in_tab_bar = false
	config.use_fancy_tab_bar = false

	-- Tab reordering keybindings
	config.keys = config.keys or {}
	table.insert(config.keys, { key = "LeftArrow", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(-1) })
	table.insert(config.keys, { key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(1) })

	-- Performance
	config.max_fps = 144

	-- Cursor
	config.default_cursor_style = "SteadyUnderline"

	-- Process icon mapping
	local function get_process_icon(process_name)
		local icons = {
			["nvim"] = wezterm.nerdfonts.custom_vim,
			["vim"] = wezterm.nerdfonts.dev_vim,
			["node"] = wezterm.nerdfonts.dev_nodejs_small,
			["python"] = wezterm.nerdfonts.dev_python,
			["git"] = wezterm.nerdfonts.dev_git,
			["cargo"] = wezterm.nerdfonts.dev_rust,
			["docker"] = wezterm.nerdfonts.linux_docker,
			["npm"] = wezterm.nerdfonts.dev_npm,
			["zsh"] = wezterm.nerdfonts.dev_terminal,
			["bash"] = wezterm.nerdfonts.dev_terminal,
			["fish"] = wezterm.nerdfonts.dev_terminal,
		}
		return icons[process_name] or wezterm.nerdfonts.cod_terminal
	end

	wezterm.on("format-tab-title", function(tab, _, _, _, hover, _)
		-- Ayu dark theme colors
		local colors = {
			active_bg = "#ffcc66", -- Ayu accent yellow
			active_fg = "#0f1419", -- Ayu dark background
			inactive_bg = "#272d38", -- Ayu darker gray
			inactive_fg = "#8a9199", -- Ayu comment gray
			hover_bg = "#3e4b59", -- Slightly lighter gray
			hover_fg = "#bfbdb6", -- Ayu foreground
		}

		local background = colors.inactive_bg
		local foreground = colors.inactive_fg

		if tab.is_active then
			background = colors.active_bg
			foreground = colors.active_fg
		elseif hover then
			background = colors.hover_bg
			foreground = colors.hover_fg
		end

		-- Get process name and icon
		local process_name = tab.active_pane.foreground_process_name
		process_name = process_name and process_name:match("([^/\\]+)$") or ""
		local icon = get_process_icon(process_name)

		-- Format tab title with index, icon, and title
		local tab_index = tab.tab_index + 1
		local title = string.format("  %d %s  ", tab_index, icon)

		return {
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
			{ Text = title },
		}
	end)
end

return ui
