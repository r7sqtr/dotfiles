return {
	"olimorris/codecompanion.nvim",
	cmd = {
		"CodeCompanion",
		"CodeCompanionChat",
		"CodeCompanionAction",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{
			"<leader>cc",
			":CodeCompanion<CR>",
			desc = "Code Companion: Open",
			mode = { "n", "v" },
			silent = true,
		},
		{
			"<leader>ca",
			":CodeCompanionChat<CR>",
			desc = "Chat: Open",
			mode = { "n", "v" },
			silent = true,
		},
		{
			"<leader>ce",
			":CodeCompanionAction<CR>",
			desc = "Default Action: Open",
			mode = { "n", "v" },
			silent = true,
		},
	},
	opts = function(_, options)
		-- 環境に依存しない設定
		local base_options = {
			progress = {
				enabled = false,
			},
			opts = {
				language = "Japanese",
			},
			display = {
				chat = {
					auto_scroll = true,
				},
			},
			-- アダプター設定でモデルを固定
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend("copilot", {
						schema = {
							model = {
								default = "gpt-5-mini",
							},
						},
					})
				end,
			},
			prompt_library = {
				["Optimize"] = {
					strategy = "chat",
					description = "Code Optimize",
					prompts = {
						{
							role = "system",
							content = "あなたは優秀なプログラマーです。選択したコードを最適化し、パフォーマンスと可読性を向上させることができます。",
						},
						{
							role = "user",
							content = "選択したコードを最適化し、パフォーマンスと可読性を向上させてください。",
						},
					},
				},
			},
		}
		-- デフォルト設定 -> 環境に依存しない設定
		return vim.tbl_deep_extend("force", options, base_options)
	end,
	config = function(_, opts)
		require("plugins.ai.extend.spinner"):init()
		require("codecompanion").setup(opts)
	end,
}
