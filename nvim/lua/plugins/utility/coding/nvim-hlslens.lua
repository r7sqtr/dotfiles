return {
	"kevinhwang91/nvim-hlslens",
	event = "VeryLazy",
	config = function()
		local hlslens = require("hlslens")
		local opts = { noremap = true, silent = true }
		hlslens.setup({
			-- オプション設定
			calm_down = false,
			nearest_only = false,
			nearest_float_when = "auto",
			float_shadow_blend = 50,
			virt_priority = 100,
		})

		-- カーソル下の単語を検索する
		vim.keymap.set("n", "*", function()
			local current_word = vim.fn.expand("<cword>")
			vim.fn.histadd("search", current_word)
			vim.fn.setreg("/", current_word)
			vim.opt.hlsearch = true
			hlslens.start()
		end, opts)

		-- カーソル下の単語を置換する
		vim.keymap.set("n", "#", function()
			local current_word = vim.fn.expand("<cword>")
			vim.api.nvim_feedkeys(":%s/" .. current_word .. "//g", "n", false)
			-- :%s/word/CURSOR/g
			local ll = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
			vim.api.nvim_feedkeys(ll, "n", false)
			vim.opt.hlsearch = true
			hlslens.start()
		end, opts)
	end,
}
