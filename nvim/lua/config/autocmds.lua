-- 保存完了時のメッセージ表示
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function(args)
		local filename = vim.fn.fnamemodify(args.file, ":~:.")
		vim.notify("🎉 Save Complete: " .. filename, vim.log.levels.INFO, { title = "Neovim" })
	end,
})

-- 外部からファイルが変更された場合は自動で読み込む
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
	pattern = "*",
	command = "checktime",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		if vim.bo.filetype == "markdown" then
			vim.wo.conceallevel = 2
		end
	end,
})
