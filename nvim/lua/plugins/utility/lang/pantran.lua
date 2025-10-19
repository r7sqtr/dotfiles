return {
	"potamides/pantran.nvim",
	keys = {
		{ "<leader>w", "<cmd>Pantran<CR>", mode = { "n", "v" }, desc = "+Translate" },
	},
	config = function()
		require("pantran").setup({
			default_engine = "google", -- デフォルトで Google 翻訳を使用
			engines = {
				google = {
					fallback = {
						default_source = "ja", -- デフォルトの入力言語
						default_target = "en", -- デフォルトの出力言語
					},
				},
			},
			ui = {
				width_percentage = 0.5,
				height_percentage = 0.5,
			},
			window = {
				title_border = { "⭐️ ", " ⭐️    " },
				window_config = { border = "rounded" },
			},
			controls = {
				mappings = {
					edit = {
						n = {
							-- 入力言語と出力言語の入れ替え
							["S"] = require("pantran.ui.actions").switch_languages,
							-- 翻訳エンジンの切り替え
							["e"] = require("pantran.ui.actions").select_engine,
							-- 入力言語の切り替え
							["s"] = require("pantran.ui.actions").select_source,
							-- 出力言語の切り替え
							["t"] = require("pantran.ui.actions").select_target,
							-- 翻訳した文字をヤンクしてウィンドウを閉じる
							["<C-y>"] = require("pantran.ui.actions").yank_close_translation,
							-- ヘルプを表示
							["g?"] = require("pantran.ui.actions").help,
							["<C-Q>"] = false,
							["gA"] = false,
							["gS"] = false,
							["gR"] = false,
							["ga"] = false,
							["ge"] = false,
							["gr"] = false,
							["gs"] = false,
							["gt"] = false,
							["gY"] = false,
							["gy"] = false,
						},
						i = {
							-- 入力言語と出力言語の入れ替え
							["<C-S>"] = require("pantran.ui.actions").switch_languages,
							-- 翻訳エンジンの切り替え
							["<C-e>"] = require("pantran.ui.actions").select_engine,
							-- 入力言語の切り替え
							["<C-s>"] = require("pantran.ui.actions").select_source,
							-- 出力言語の切り替え
							["<C-t>"] = require("pantran.ui.actions").select_target,
							-- 翻訳した文字をヤンクしてウィンドウを閉じる
							["<C-y>"] = require("pantran.ui.actions").yank_close_translation,
						},
					},
					select = {},
				},
			},
		})
	end,
}
