-- 基本設定
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8,sjis,euc-jp,latin1" -- デフォルトのエンコーディング候補
vim.opt.clipboard = "unnamedplus"
vim.g.format_on_save = false

-- 表示系
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.title = true
vim.opt.cursorline = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
-- vim.opt.laststatus = 3
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
vim.opt.wildignore:append({
	"*/node_modules/*",
	"*/vendor/*",
	"*.png",
  "*.jpg",
  "*.webp",
  "*.svg",
})

-- ウィンドウ分割・UI
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = "a"

vim.opt.laststatus = 0
vim.opt.statusline = "─"
vim.opt.fillchars:append({ stl = "─", stlnc = "─" })

-- フォーマットオプション
vim.opt.formatoptions:append({ "r" })
