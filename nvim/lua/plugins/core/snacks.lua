return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader><space>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		-- {
		-- 	"<leader>e",
		-- 	function()
		-- 		Snacks.explorer()
		-- 	end,
		-- 	desc = "File Explorer",
		-- },
		-- {
		-- 	"<leader>fb",
		-- 	function()
		-- 		Snacks.picker.git_branches()
		-- 	end,
		-- 	desc = "Git Branches",
		-- },
		-- {
		-- 	"<leader>fp",
		-- 	function()
		-- 		Snacks.picker.projects()
		-- 	end,
		-- 	desc = "Projects",
		-- },
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = "Goto References",
		},
	},
	opts = {
		indent = { enabled = false },
		image = { enabled = false },
		input = { enabled = false },
		notifier = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		include = { "*" },
		exclude = { ".git", "node_modules", "dist", ".DS_Store" },
		picker = {
			enabled = true,
			matcher = {
				fuzzy = true, -- use fuzzy matching
				smartcase = true, -- use smartcase
				ignorecase = true, -- use ignorecase
				sort_empty = false, -- sort results when the search string is empty
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true, -- support patterns like `file:line:col` and `file:line`
				cwd_bonus = false, -- give bonus for matching files in the cwd
				frecency = true, -- frecency bonus
				history_bonus = false, -- give more weight to chronological order
			},
			formatters = {
				text = {
					ft = nil, ---@type string? filetype for highlighting
				},
				file = {
					filename_first = true, -- display filename before the file path
					truncate = 40, -- truncate the file path to (roughly) this length
					filename_only = false, -- only show the filename
					icon_width = 2, -- width of the icon (in characters)
					git_status_hl = true, -- use the git status highlight group for the filename
				},
				selected = {
					show_always = false, -- only show the selected column when there are multiple selections
					unselected = true, -- use the unselected icon for unselected items
				},
				severity = {
					icons = true, -- show severity icons
					level = false, -- show severity level
					---@type "left"|"right"
					pos = "left", -- position of the diagnostics
				},
			},
			sources = {
				explorer = {
					icons = {
						files = {
							enabled = true,
							dir = "󰉋 ",
							dir_open = "󰝰 ",
							file = "󰈔 ",
						},
						keymaps = {
							nowait = "󰓅 ",
						},
						tree = {
							vertical = "│ ",
							middle = "├╴",
							last = "└╴",
						},
						undo = {
							saved = " ",
						},
						ui = {
							live = "󰐰 ",
							hidden = "h",
							ignored = "i",
							follow = "f",
							selected = "◀",
							unselected = "▶",
						},
						git = {
							enabled = true,
							commit = "󰜘 ",
							staged = "",
							added = "",
							deleted = "",
							ignored = " ",
							modified = "",
							renamed = "",
							unmerged = "",
							untracked = "",
						},
						diagnostics = {
							Error = " ",
							Warn = " ",
							Info = " ",
						},
						lsp = {
							unavailable = "",
							enabled = " ",
							disabled = " ",
							attached = "󰖩 ",
						},
						kinds = {
							Array = " ",
							Boolean = "󰨙 ",
							Class = " ",
							Color = " ",
							Control = " ",
							Collapsed = " ",
							Constant = "󰏿 ",
							Constructor = " ",
							Copilot = " ",
							Enum = " ",
							EnumMember = " ",
							Event = " ",
							Field = " ",
							File = " ",
							Folder = " ",
							Function = "󰊕 ",
							Interface = " ",
							Key = " ",
							Keyword = " ",
							Method = "󰊕 ",
							Module = " ",
							Namespace = "󰦮 ",
							Null = " ",
							Number = "󰎠 ",
							Object = " ",
							Operator = " ",
							Package = " ",
							Property = " ",
							Reference = " ",
							Snippet = "󱄽 ",
							String = " ",
							Struct = "󰆼 ",
							Text = " ",
							TypeParameter = " ",
							Unit = " ",
							Unknown = " ",
							Value = " ",
							Variable = "󰀫 ",
						},
					},
				},
			},
			previewers = {
				diff = {
					builtin = true, -- use Neovim for previewing diffs (true) or use an external tool (false)
					cmd = { "delta" }, -- example to show a diff with delta
				},
				git = {
					builtin = true, -- use Neovim for previewing git output (true) or use git (false)
					args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
				},
				file = {
					max_size = 1024 * 1024, -- 1MB
					max_line_length = 500, -- max line length
					ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
				},
				man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
			},
		},
		explorer = {
			enabled = false,
			position = "left",
			width = 40,
			open_on_startup = false,
			open_on_current_file = false,
			follow_current_file = false,
			show_hidden_files = true,
			show_git_status = true,
			show_root = true,
		},
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "p",
						desc = "project",
						action = ":lua Snacks.picker.projects()",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
		},
	},
}
