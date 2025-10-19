return {
	"johmsalas/text-case.nvim",
	event = "VeryLazy",
	dependencies = {
		"folke/snacks.nvim",
	},
	config = function()
		require("textcase").setup({})
		local plugin = require("textcase.plugin.plugin")
		local picker = require("snacks.picker")
		local constants = require("textcase.shared.constants")
		local api = require("textcase").api
		local api_list = {
			api.to_upper_case,
			api.to_lower_case,
			api.to_snake_case,
			api.to_dash_case,
			api.to_title_dash_case,
			api.to_constant_case,
			api.to_dot_case,
			api.to_comma_case,
			api.to_phrase_case,
			api.to_camel_case,
			api.to_pascal_case,
			api.to_title_case,
			api.to_path_case,
		}

		local function create_items(mode)
			local items = {}
			local conversion_dict = {}
			if mode == "n" then
				table.insert(conversion_dict, { prefix = "Convert to ", type = constants.change_type.CURRENT_WORD })
				table.insert(conversion_dict, { prefix = "Lsp rename ", type = constants.change_type.LSP_RENAME })
			else
				table.insert(conversion_dict, { prefix = "Convert to ", type = constants.change_type.VISUAL })
			end

			local i = 1
			for _, conversion in pairs(conversion_dict) do
				for _, method in pairs(api_list) do
					local item = {
						idx = i,
						score = 0,
						text = conversion.prefix .. method.desc,
						method_name = method.method_name,
						type = conversion.type,
					}
					table.insert(items, item)
					i = i + 1
				end
			end
			return items
		end

		local function invoke_replacement(the_picker, item)
			the_picker:close()
			if item.type == constants.change_type.CURRENT_WORD then
				plugin.current_word(item.method_name)
			elseif item.type == constants.change_type.LSP_RENAME then
				plugin.lsp_rename(item.method_name)
			elseif item.type == constants.change_type.VISUAL then
				plugin.visual(item.method_name)
			end
		end

		vim.keymap.set({ "n", "v" }, "<leader>fk", function()
			local mode = vim.api.nvim_get_mode().mode
			if mode ~= "n" then
				mode = "v"
			end
			picker({
				finder = function()
					return create_items(mode)
				end,
				confirm = invoke_replacement,
				format = "text",
				preview = "none",
				layout = { preset = "vscode" },
			})
		end, { desc = "Picker: textcase" })
	end,
}
