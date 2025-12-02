return {
	"b0o/incline.nvim",
	event = "BufReadPre",
	priority = 1200,
	config = function()
		local function get_hl_color(name)
			local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
			return hl.fg and string.format("#%06x", hl.fg) or nil
		end

		local diagnostic_config = {
			{ severity = vim.diagnostic.severity.ERROR, icon = "󰬌", hl = "DiagnosticError" },
			{ severity = vim.diagnostic.severity.WARN, icon = "󰬞", hl = "DiagnosticWarn" },
			{ severity = vim.diagnostic.severity.INFO, icon = "󰬐", hl = "DiagnosticInfo" },
			{ severity = vim.diagnostic.severity.HINT, icon = "󰬏", hl = "DiagnosticHint" },
		}

		require("incline").setup({
			window = { margin = { vertical = 0, horizontal = 1 } },
			hide = {
				cursorline = true,
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				local icon, color = require("nvim-web-devicons").get_icon_color(filename)

				-- LSP診断情報を取得
				local diagnostics = vim.diagnostic.get(props.buf)
				local count = {}
				for _, d in ipairs(diagnostics) do
					count[d.severity] = (count[d.severity] or 0) + 1
				end

				local result = {}

				-- 診断情報を表示
				local has_diagnostics = false
				for _, config in ipairs(diagnostic_config) do
					local cnt = count[config.severity]
					if cnt and cnt > 0 then
						if has_diagnostics then
							table.insert(result, { " " })
						end
						table.insert(result, {
							config.icon .. " " .. cnt,
							guifg = get_hl_color(config.hl),
						})
						has_diagnostics = true
					end
				end

				-- 診断情報がある場合は区切りを追加
				if has_diagnostics then
					table.insert(result, { " ┊ ", guifg = get_hl_color("Comment") })
				end

				-- ファイルアイコンとファイル名
				table.insert(result, { icon, guifg = color })
				table.insert(result, { " " })
				table.insert(result, { filename })

				-- 変更がある場合は●を表示
				if vim.bo[props.buf].modified then
					table.insert(result, { " ●", guifg = get_hl_color("DiagnosticWarn") })
				end

				return result
			end,
		})
	end,
}
