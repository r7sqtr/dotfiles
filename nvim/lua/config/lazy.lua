local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		{ import = "plugins.ai" },
		{ import = "plugins.colorschemes" },
		{ import = "plugins.utility.coding" },
		{ import = "plugins.utility.git" },
		{ import = "plugins.utility.lang" },
		{ import = "plugins.utility.ui" },
		{ import = "plugins.core" },
		{ import = "plugins.lsp" },
		{ import = "plugins.lsp.lang" },
	},
	defaults = {
		lazy = true,
		version = false,
	},
	checker = {
		enabled = true,
		notify = false,
	},
})
