return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	keys = {
		{
			"<leader><space>",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>/",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>fo",
			function()
				require("fzf-lua").oldfiles()
			end,
			desc = "Old Files",
		},
		{
			"<leader>gs",
			function()
				require("fzf-lua").git_status()
			end,
			desc = "Git Status",
		},
		{
			"gd",
			function()
				require("fzf-lua").lsp_definitions()
			end,
			desc = "Go to Definition",
		},
		{
			"gr",
			function()
				require("fzf-lua").lsp_references()
			end,
			desc = "Go to References",
		},
		{
			"<leader>fs",
			function()
				require("fzf-lua").lsp_document_symbols()
			end,
			desc = "Document Symbols",
		},
		-- カスタム設定（Config検索）
		{
			"<leader>fc",
			function()
				require("fzf-lua").files({ cwd = vim.fn.stdpath("config"), prompt = "Config❯ " })
			end,
			desc = "Neovim Config",
		},
	},

	config = function()
		local fzf = require("fzf-lua")
		local actions = require("fzf-lua.actions")

		-- LuaLSの警告回避
		---@diagnostic disable-next-line: missing-fields
		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.80,
				row = 0.5,
				col = 0.5,
				preview = {
					layout = "flex",
					scrollbar = "float",
				},
			},
			keymap = {
				builtin = {
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
					["<C-/>"] = "toggle-help",
				},
				fzf = {
					["ctrl-z"] = "abort",
					["ctrl-q"] = "select-all+accept",
				},
			},
			files = {
				prompt = "Files❯ ",
				multiprocess = true,
				-- 画像除外設定
				cmd = "fd --type f --hidden --follow --exclude .git "
					.. "--exclude '*.png' --exclude '*.jpg' --exclude '*.jpeg' "
					.. "--exclude '*.gif' --exclude '*.webp' --exclude '*.svg' --exclude '*.ico'",
				git_icons = true,
				file_icons = true,
				color_icons = true,
				actions = {
					["ctrl-q"] = actions.file_edit_or_qf,
					["ctrl-x"] = actions.file_split,
					["ctrl-v"] = actions.file_vsplit,
				},
			},
			grep = {
				prompt = "Rg❯ ",
				input_prompt = "Grep For❯ ",
				multiprocess = true,
				rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -g '!.git'",
				actions = {
					["ctrl-q"] = actions.file_edit_or_qf,
				},
			},
			git = {
				files = { prompt = "GitFiles❯ ", cmd = "git ls-files --exclude-standard --cached --others" },
				status = { prompt = "GitStatus❯ " },
				commits = { prompt = "Commits❯ " },
				bcommits = { prompt = "BCommits❯ " },
			},
		})
	end,
}
