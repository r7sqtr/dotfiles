-- lua/plugins/neo-tree.lua など
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = { "Neotree" },
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "File Explorer" },
	},
	opts = {
		close_if_last_window = true,
		sources = { "filesystem", "git_status" },
		default_source = "filesystem",
		enable_git_status = true,
		enable_diagnostics = false,

		-- NETRW 置き換え（競合回避用）
		hijack_netrw_behavior = "open_default", -- "open_current" | "disabled"

		filesystem = {
			bind_to_cwd = true,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = false, -- true にすると .gitignore 系も一覧に表示
				hide_dotfiles = false,
				hide_gitignored = true,
				hide_by_name = { "node_modules", ".git" },
				never_show = { ".DS_Store" },
			},
			window = {
				position = "left", -- "left" | "right" | "float"

				mappings = {
					[","] = "toggle_node",
					["<CR>"] = "open",
					["o"] = "open",
					["s"] = "open_split",
					["v"] = "open_vsplit",
					["t"] = "open_tabnew",
					["h"] = "close_node",
					["l"] = "open",
					["a"] = { "add", config = { show_path = "relative" } },
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["R"] = "refresh",
					["q"] = "close_window",
				},
			},
		},

		buffers = {
			follow_current_file = { enabled = true },
			window = { mappings = { ["bd"] = "buffer_delete" } },
		},

		git_status = {
			window = {
				mappings = {
					["gA"] = "git_add_all",
					["ga"] = "git_add_file",
					["gu"] = "git_unstage_file",
          ["gU"] = "git_unstage_all",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
				},
			},
		},

		-- ソース切替タブ（上部の選択UI）
		source_selector = {
			winbar = true,
			content_layout = "center",
			sources = {
				{ source = "filesystem", display_name = "  Files " },
				{ source = "git_status", display_name = "  Git " },
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
	end,
}
