-- WebView module for WezBrowser
local wezterm = require("wezterm")
local act = wezterm.action

local webview = {}

function webview.setup(config)
	-- Add WebView key bindings to existing keys
	local webview_keys = {
		-- Open URL prompt (Option+Shift+O) - right split
		{
			key = "o",
			mods = "ALT|SHIFT",
			action = act.PromptInputLine({
				description = "Enter URL to open in WebView (right split):",
				action = wezterm.action_callback(function(window, pane, line)
					if line and line ~= "" then
						local url = line
						if not url:match("^https?://") then
							url = "https://" .. url
						end
						window:perform_action(
							act.SplitWebView({
								url = url,
								direction = "Right",
							}),
							pane
						)
					end
				end),
			}),
		},
		-- Open URL prompt (Option+Shift+U) - bottom split
		{
			key = "u",
			mods = "ALT|SHIFT",
			action = act.PromptInputLine({
				description = "Enter URL to open in WebView (bottom split):",
				action = wezterm.action_callback(function(window, pane, line)
					if line and line ~= "" then
						local url = line
						if not url:match("^https?://") then
							url = "https://" .. url
						end
						window:perform_action(
							act.SplitWebView({
								url = url,
								direction = "Down",
							}),
							pane
						)
					end
				end),
			}),
		},
		-- Quick access: Google (Option+Shift+G)
		{
			key = "g",
			mods = "ALT|SHIFT",
			action = act.SplitWebView({
				url = "https://www.google.com",
				direction = "Right",
			}),
		},
		-- Quick access: GitHub (Option+Shift+H)
		{
			key = "h",
			mods = "ALT|SHIFT",
			action = act.SplitWebView({
				url = "https://github.com",
				direction = "Down",
			}),
		},
		-- Navigation: Go back (Option+[)
		{
			key = "[",
			mods = "ALT",
			action = act.WebViewGoBack,
		},
		-- Navigation: Go forward (Option+])
		{
			key = "]",
			mods = "ALT",
			action = act.WebViewGoForward,
		},
		-- Navigation: Reload (Option+R)
		{
			key = "r",
			mods = "ALT",
			action = act.WebViewReload,
		},
		-- Close pane without confirmation (Option+W)
		{
			key = "w",
			mods = "ALT",
			action = act.CloseCurrentPane({ confirm = false }),
		},
	}

	-- Append to existing keys
	config.keys = config.keys or {}
	for _, key in ipairs(webview_keys) do
		table.insert(config.keys, key)
	end
end

return webview
