local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Tab Movement
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Move window
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- Exchange a to i
keymap.set("n", "a", "i")
keymap.set("n", "i", "a")

-- disable
keymap.set("n", "s", "<Nop>")

-- Paste to the front of the line
keymap.set("n", "p", "0p")

keymap.set("n", "<M-j>", "<Cmd>move .+1<CR>==")
keymap.set("x", "<M-j>", ":move '>+1<CR>gv=gv")
keymap.set("n", "<M-k>", "<Cmd>move .-2<CR>==")
keymap.set("x", "<M-k>", ":move '<-2<CR>gv=gv")

keymap.set("i", "<C-BS>", "<C-u>", { noremap = true })

-- VSCode(VSCode Neovim) 上でのみ有効化
if vim.g.vscode then
	vim.g.mapleader = " " -- <leader> = Space

	-- Explorer トグル
	keymap.set("n", "<leader>e", function()
		vim.fn.VSCodeNotify("workbench.action.toggleSidebarVisibility")
	end, opts)

	-- ファイル検索 (⌘/Ctrl + P と同等)
	keymap.set("n", "<leader><Space>", function()
		vim.fn.VSCodeNotify("workbench.action.quickOpen")
	end, opts)

	-- シンボル検索
	keymap.set("n", "<leader>t", function()
		vim.fn.VSCodeNotify("workbench.action.gotoSymbol")
	end, opts)

	-- コマンドパレット
	-- keymap.set("n", "<C-t>", function()
	-- 	vim.fn.VSCodeNotify("workbench.action.terminal.toggleTerminal")
	-- end, opts)

	-- エディタグループ移動（ウィンドウ移動）
	keymap.set("n", "sh", function()
		vim.fn.VSCodeNotify("workbench.action.focusLeftGroup")
	end, opts)
	keymap.set("n", "sl", function()
		vim.fn.VSCodeNotify("workbench.action.focusBelowGroup")
	end, opts)
	keymap.set("n", "sj", function()
		vim.fn.VSCodeNotify("workbench.action.focusAboveGroup")
	end, opts)
	keymap.set("n", "sk", function()
		vim.fn.VSCodeNotify("workbench.action.focusRightGroup")
	end, opts)

	-- 定義ジャンプ
	keymap.set("n", "gd", function()
		vim.fn.VSCodeNotify("editor.action.revealDefinition")
	end, opts)

	-- 参照ジャンプ
	keymap.set("n", "gr", function()
		vim.fn.VSCodeNotify("editor.action.referenceSearch.trigger")
	end, opts)

	-- コメントトグル（ノーマル/ビジュアル）
	keymap.set("n", "gcc", function()
		vim.fn.VSCodeNotify("editor.action.commentLine")
	end, opts)
	keymap.set("x", "gc", function()
		vim.fn.VSCodeNotifyVisual("editor.action.commentLine", 1)
	end, opts)

	-- 検索置換
	keymap.set("n", "<leader>f", function()
		vim.fn.VSCodeNotify("actions.find")
	end, opts)
	keymap.set("n", "<leader>r", function()
		vim.fn.VSCodeNotify("editor.action.startFindReplaceAction")
	end, opts)

	-- jk で挿入モード離脱
	keymap.set("i", "jk", "<Esc>", opts)
end
