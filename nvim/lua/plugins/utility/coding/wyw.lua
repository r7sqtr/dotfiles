return {
	"r7sqtr/wyw.nvim",
	cmd = { "Wyw", "WywRefresh", "WywClose", "WywToggle" },
	config = function()
		require("wyw").setup({
			sources = {
				-- Hacker News
				hackernews = {
					enabled = false,
					limit = 30,
					type = "top", -- "top" | "new" | "best" | "ask" | "show"
				},
				-- 汎用RSSフィード
				rss = {
					feeds = {
						-- { name = "Lobsters", url = "https://lobste.rs/rss" },
						-- { name = "Dev.to", url = "https://dev.to/feed" },
					},
				},
				-- Zenn
				zenn = {
					enabled = true,
					topics = {
						"vim",
						"neovim",
						"claude",
						"ai",
					},
					users = {},
				},
				-- Qiita
				qiita = {
					enabled = true,
					tags = {
						"neovim",
						"vim",
						"claude",
						"ai",
					},
					users = {},
				},
				-- DevelopersIO (Classmethod)
				developerio = {
					enabled = true,
					use_daily = false,
					authors = {},
				},
			},
			ui = {
				display_mode = "buffer", -- "float" | "side" | "buffer"
				float = {
					width = 80,
					height = 25,
					border = "rounded",
					title = " wyw.nvim ",
				},
				side = {
					position = "right", -- "left" | "right"
					width = 50,
				},
				buffer = {
					split = "tab", -- "vertical" | "horizontal" | "tab"
				},
			},
			cache = {
				enabled = true,
				ttl = 300, -- 5分
				path = vim.fn.stdpath("cache") .. "/wyw",
			},
			date_format = "%Y-%m-%d %H:%M",
			keymaps = {
				close = { "q", "<Esc>" },
				refresh = "r",
				open_link = "<CR>",
				next_item = "j",
				prev_item = "k",
				scroll_down = "<C-d>",
				scroll_up = "<C-u>",
			},
		})
	end,
}
