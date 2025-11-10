local wezterm = require("wezterm")
local io = require("io")

local colorscheme = {}

-- Get the path to the color scheme data file
local function get_colorscheme_data_path()
	local config_dir = wezterm.config_dir
	return config_dir .. "/config/colorscheme_data.lua"
end

-- Save the color scheme to file
local function save_color_scheme(scheme_name)
	local data_path = get_colorscheme_data_path()

	-- Write to file
	local file = io.open(data_path, "w")
	if not file then
		wezterm.log_error("Failed to write to color scheme file: " .. data_path)
		return false
	end

	file:write('-- This file is automatically updated by the color scheme picker\n')
	file:write('return "' .. scheme_name .. '"\n')
	file:close()

	wezterm.log_info("Saved color scheme: " .. scheme_name)
	return true
end

-- Apply color scheme to config
function colorscheme.setup(config)
	local data_path = get_colorscheme_data_path()
	local success, scheme_name = pcall(function()
		return dofile(data_path)
	end)

	if success and scheme_name then
		config.color_scheme = scheme_name
		wezterm.log_info("Loaded color scheme: " .. scheme_name)
	else
		-- Default value
		config.color_scheme = "ayu"
		wezterm.log_info("Using default color scheme: ayu")
	end
end

-- Display color scheme picker
function colorscheme.pick(window, pane)
	-- Get all builtin color schemes
	local schemes = wezterm.color.get_builtin_schemes()
	local choices = {}

	-- Build the choices list (color palette on left, scheme name on right)
	for name, scheme in pairs(schemes) do
		local format_items = {}

		-- Left side: Display ANSI 8 colors as background
		if scheme.ansi and #scheme.ansi >= 8 then
			for i = 1, 8 do
				table.insert(format_items, { Background = { Color = scheme.ansi[i] } })
				table.insert(format_items, { Text = "  " })
			end
			table.insert(format_items, "ResetAttributes")
		end

		-- Separator
		table.insert(format_items, { Text = " " })

		-- Right side: Display scheme name with actual background and foreground colors
		if scheme.background and scheme.foreground then
			table.insert(format_items, { Background = { Color = scheme.background } })
			table.insert(format_items, { Foreground = { Color = scheme.foreground } })
			table.insert(format_items, { Text = " " .. name .. " " })
			table.insert(format_items, "ResetAttributes")
		else
			-- Display normally if background or foreground color is missing
			table.insert(format_items, { Text = name })
		end

		local label = wezterm.format(format_items)

		table.insert(choices, {
			id = name,
			label = label,
		})
	end

	-- Sort alphabetically
	table.sort(choices, function(a, b)
		return a.id < b.id
	end)

	-- Display InputSelector
	window:perform_action(
		wezterm.action.InputSelector({
			title = "🎨 Select Color Scheme",
			choices = choices,
			fuzzy = true,
			fuzzy_description = "Search by color scheme name...",
			action = wezterm.action_callback(function(inner_window, _, id, _)
				if not id then
					wezterm.log_info("Color scheme selection cancelled")
					return
				end

				-- Apply immediately (temporary change)
				inner_window:set_config_overrides({ color_scheme = id })

				-- Save to file (persistent change)
				if save_color_scheme(id) then
					wezterm.log_info("Applied color scheme: " .. id)
				else
					wezterm.log_error("Failed to save color scheme")
				end
			end),
		}),
		pane
	)
end

return colorscheme
