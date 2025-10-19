return {
	"danymat/neogen",
	event = "VeryLazy",
	dependencies = "nvim-treesitter/nvim-treesitter", -- 必須
	config = function()
		require("neogen").setup({
			enabled = true,
			snippet_engine = "luasnip", -- luasnip / vsnip / ultisnips に対応
			languages = {
				-- PHP
				php = {
					template = {
						annotation_convention = "phpdoc", -- PHPDoc スタイル
					},
				},
				-- JavaScript
				javascript = {
					template = {
						annotation_convention = "jsdoc", -- JSDoc スタイル
					},
				},
				-- TypeScript
				typescript = {
					template = {
						annotation_convention = "tsdoc", -- TSDoc / JSDoc スタイル
					},
				},
				-- Go
				go = {
					template = {
						annotation_convention = "godoc", -- GoDoc スタイル
					},
				},
				-- Python
				python = {
					template = {
						annotation_convention = "google_docstrings", -- Google / Numpy / reST など切替可
					},
				},
			},
		})

		-- キーマップ設定
		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<leader>cm", ":Neogen func<CR>", opts) -- 関数コメント
		vim.keymap.set("n", "<leader>cn", ":Neogen class<CR>", opts) -- クラスコメント
	end,
}
