-- 基本設定
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.clipboard = "unnamedplus"
vim.g.format_on_save = false

-- 表示系
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.title = true
vim.opt.cursorline = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.scrolloff = 15
vim.opt.wrap = false
vim.opt.fillchars = { eob = " " }
vim.opt.list = true
vim.opt.listchars = { tab = "··", trail = "·", extends = ">", precedes = "<", space = "·" }

-- インデント・タブ
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.backspace = { "start", "eol", "indent" }

-- 検索・コマンドライン
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.shortmess:append("W")

-- ファイル・バックアップ
vim.opt.backup = false
vim.opt.swapfile = false

-- ファイル探索
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })

-- ウィンドウ分割・UI
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = "a"

-- 診断・LSP
local sev = vim.diagnostic.severity
vim.diagnostic.config({
	virtual_text = {
		prefix = "▎",
		spacing = 2,
		severity = { min = sev.WARN },
	},
	signs = {
		text = {
			[sev.ERROR] = "▐",
			[sev.WARN] = "▐",
			[sev.HINT] = "▐",
			[sev.INFO] = "▐",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- フォーマットオプション
vim.opt.formatoptions:append({ "r" })
