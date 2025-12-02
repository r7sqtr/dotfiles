return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- Diagnostic signs
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰬌",
					[vim.diagnostic.severity.WARN] = "󰬞",
					[vim.diagnostic.severity.INFO] = "󰬐",
					[vim.diagnostic.severity.HINT] = "󰬏",
				},
			},
		})
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Enable snippet support
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		-- Customize hover window with borders
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
			max_width = 80,
		})

		-- Customize signature help window with borders
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			max_width = 80,
		})

		---@param client vim.lsp.Client
		---@param bufnr integer
		local on_attach = function(client, bufnr)
			local opts = { buffer = bufnr, silent = true }

			-- Enable inlay hints if supported
			if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end

			-- Keymaps (LSP operations)
			vim.keymap.set(
				"n",
				"<leader>rn",
				vim.lsp.buf.rename,
				vim.tbl_extend("force", opts, { desc = "Rename Symbol" })
			)

			-- Document highlight (if supported)
			if client.server_capabilities.documentHighlightProvider then
				local group = vim.api.nvim_create_augroup("LSPDocumentHighlight_" .. bufnr, { clear = true })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = bufnr,
					group = group,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd("CursorMoved", {
					buffer = bufnr,
					group = group,
					callback = vim.lsp.buf.clear_references,
				})
			end

			-- Format on save (if formatting is enabled via conform.nvim)
			-- Note: Actual formatting is delegated to conform.nvim
		end
		-- This will be used by mason-lspconfig.lua to setup servers
		_G.lsp_base_config = {
			capabilities = capabilities,
			on_attach = on_attach,
		}
	end,
}
