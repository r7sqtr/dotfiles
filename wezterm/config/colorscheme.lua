local wezterm = require("wezterm")
local io = require("io")

local colorscheme = {}

-- カラースキームデータファイルのパスを取得
local function get_colorscheme_data_path()
	local config_dir = wezterm.config_dir
	return config_dir .. "/config/colorscheme_data.lua"
end

-- お気に入りファイルのパスを取得
local function get_favorites_path()
	return wezterm.config_dir .. "/config/colorscheme_favorites.lua"
end

-- お気に入りリストを読み込み
local function load_favorites()
	local success, favorites = pcall(function()
		return dofile(get_favorites_path())
	end)
	if success and type(favorites) == "table" then
		return favorites
	end
	return {}
end

-- お気に入りリストを保存
local function save_favorites(favorites)
	local file = io.open(get_favorites_path(), "w")
	if not file then
		wezterm.log_error("Failed to write favorites file: " .. get_favorites_path())
		return false
	end

	file:write("-- このファイルはお気に入り機能によって自動更新されます\n")
	file:write("return {\n")
	for _, name in ipairs(favorites) do
		-- 特殊文字をエスケープ
		local escaped = name:gsub("\\", "\\\\"):gsub('"', '\\"')
		file:write('\t"' .. escaped .. '",\n')
	end
	file:write("}\n")
	file:close()
	return true
end

-- カラースキームをファイルに保存
local function save_color_scheme(scheme_name)
	local data_path = get_colorscheme_data_path()

	local file = io.open(data_path, "w")
	if not file then
		wezterm.log_error("Failed to write to color scheme file: " .. data_path)
		return false
	end

	file:write("-- This file is automatically updated by the color scheme picker\n")
	file:write('return "' .. scheme_name .. '"\n')
	file:close()

	wezterm.log_info("Saved color scheme: " .. scheme_name)
	return true
end

-- スキーム選択時のコールバック（共通処理）
local function on_scheme_selected(inner_window, id)
	if not id then
		wezterm.log_info("Color scheme selection cancelled")
		return
	end

	inner_window:set_config_overrides({ color_scheme = id })

	if save_color_scheme(id) then
		wezterm.log_info("Applied color scheme: " .. id)
	else
		wezterm.log_error("Failed to save color scheme")
	end
end

-- スキームのラベルを生成
local function build_scheme_label(name, scheme, fav)
	local f = {}

	-- お気に入りマーク
	table.insert(f, { Text = fav and "★ " or "  " })

	-- 16色パレット: ▀ で ansi(fg) + brights(bg) を重ねて表示
	if scheme.ansi and scheme.brights and #scheme.ansi >= 8 and #scheme.brights >= 8 then
		for i = 1, 8 do
			table.insert(f, { Foreground = { Color = scheme.ansi[i] } })
			table.insert(f, { Background = { Color = scheme.brights[i] } })
			table.insert(f, { Text = "▀▀" })
		end
		table.insert(f, "ResetAttributes")
	elseif scheme.ansi and #scheme.ansi >= 8 then
		for i = 1, 8 do
			table.insert(f, { Background = { Color = scheme.ansi[i] } })
			table.insert(f, { Text = "  " })
		end
		table.insert(f, "ResetAttributes")
	end

	table.insert(f, { Text = "  " })

	-- スキーム名（背景+前景カラー付き）
	if scheme.background and scheme.foreground then
		table.insert(f, { Background = { Color = scheme.background } })
		table.insert(f, { Foreground = { Color = scheme.foreground } })
		table.insert(f, { Text = "  " .. name .. "  " })
		table.insert(f, "ResetAttributes")
	else
		table.insert(f, { Text = name })
	end

	return wezterm.format(f)
end

-- 現在のスキームをお気に入りにトグル
local function toggle_favorite(window)
	local overrides = window:get_config_overrides() or {}
	local current = overrides.color_scheme
	if not current then
		local data_path = get_colorscheme_data_path()
		local success, scheme_name = pcall(function()
			return dofile(data_path)
		end)
		current = (success and scheme_name) or "ayu"
	end

	local favorites = load_favorites()
	local found = false
	local new_favorites = {}

	for _, name in ipairs(favorites) do
		if name == current then
			found = true
		else
			table.insert(new_favorites, name)
		end
	end

	if not found then
		table.insert(new_favorites, current)
		table.sort(new_favorites)
	end

	if save_favorites(new_favorites) then
		if found then
			window:toast_notification("wezterm", "お気に入りから削除: " .. current, nil, 3000)
		else
			window:toast_notification("wezterm", "お気に入りに追加: " .. current, nil, 3000)
		end
	else
		window:toast_notification("wezterm", "お気に入りの保存に失敗しました", nil, 3000)
	end
end

-- カラースキームを設定に適用
function colorscheme.setup(config)
	local data_path = get_colorscheme_data_path()
	local success, scheme_name = pcall(function()
		return dofile(data_path)
	end)

	if success and scheme_name then
		config.color_scheme = scheme_name
		wezterm.log_info("Loaded color scheme: " .. scheme_name)
	else
		config.color_scheme = "ayu"
		wezterm.log_info("Using default color scheme: ayu")
	end
end

-- 背景色からlight系スキームか判定
local function is_light_scheme(scheme)
	if not scheme.background then return false end
	local r, g, b = scheme.background:match("#(%x%x)(%x%x)(%x%x)")
	if not r then return false end
	local luminance = 0.2126 * tonumber(r, 16) / 255
		+ 0.7152 * tonumber(g, 16) / 255
		+ 0.0722 * tonumber(b, 16) / 255
	return luminance > 0.5
end

-- 現在のスキーム名を取得
local function get_current_scheme(window)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme then return overrides.color_scheme end
	local success, name = pcall(function() return dofile(get_colorscheme_data_path()) end)
	return (success and name) or "ayu"
end

-- フィルタ済みスキーム一覧を表示
local function show_schemes(window, pane, filter)
	local schemes = wezterm.color.get_builtin_schemes()
	local fav_set = {}
	for _, name in ipairs(load_favorites()) do
		fav_set[name] = true
	end

	local choices = {}
	for name, scheme in pairs(schemes) do
		local fav = fav_set[name] or false
		local include = false
		if filter == "favorites" then
			include = fav
		elseif filter == "dark" then
			include = not is_light_scheme(scheme)
		elseif filter == "light" then
			include = is_light_scheme(scheme)
		end
		if include then
			table.insert(choices, {
				id = name,
				label = build_scheme_label(name, scheme, fav),
				_fav = fav,
			})
		end
	end

	table.sort(choices, function(a, b)
		if a._fav ~= b._fav then return a._fav end
		return a.id < b.id
	end)

	local final = {}
	for _, c in ipairs(choices) do
		table.insert(final, { id = c.id, label = c.label })
	end

	local titles = { favorites = "Favorites", dark = "Dark Schemes", light = "Light Schemes" }
	window:perform_action(
		wezterm.action.InputSelector({
			title = titles[filter] or "Color Scheme",
			choices = final,
			fuzzy = true,
			fuzzy_description = "Search by name",
			action = wezterm.action_callback(function(inner_window, _, id, _)
				if id then on_scheme_selected(inner_window, id) end
			end),
		}),
		pane
	)
end

-- カテゴリ選択メニュー
function colorscheme.pick(window, pane)
	local schemes = wezterm.color.get_builtin_schemes()
	local favorites = load_favorites()
	local fav_set = {}
	for _, name in ipairs(favorites) do fav_set[name] = true end

	-- カテゴリ別の件数を集計
	local dark_count, light_count = 0, 0
	for _, scheme in pairs(schemes) do
		if is_light_scheme(scheme) then
			light_count = light_count + 1
		else
			dark_count = dark_count + 1
		end
	end

	local current = get_current_scheme(window)
	local fav_mark = fav_set[current] and "★ " or ""

	local choices = {
		{ id = "__toggle_favorite__", label = fav_mark .. "Toggle favorite: " .. current },
		{ id = "__favorites__", label = "★ Favorites (" .. #favorites .. ")" },
		{ id = "__dark__", label = "Dark (" .. dark_count .. ")" },
		{ id = "__light__", label = "Light (" .. light_count .. ")" },
	}

	window:perform_action(
		wezterm.action.InputSelector({
			title = "Color Scheme",
			choices = choices,
			fuzzy = false,
			action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
				if not id or id == "__sep__" then return end
				if id == "__toggle_favorite__" then
					toggle_favorite(inner_window)
				elseif id == "__favorites__" then
					show_schemes(inner_window, inner_pane, "favorites")
				elseif id == "__dark__" then
					show_schemes(inner_window, inner_pane, "dark")
				elseif id == "__light__" then
					show_schemes(inner_window, inner_pane, "light")
				end
			end),
		}),
		pane
	)
end

return colorscheme
