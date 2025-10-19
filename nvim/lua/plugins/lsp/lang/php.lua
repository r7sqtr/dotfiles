return {
	{
		-- Adds the ability to use Goto File on Blade views to jump to components and other views using gf.
		"ricardoramirezr/blade-nav.nvim",
		dependencies = { -- totally optional
			"hrsh7th/nvim-cmp", -- if using nvim-cmp
		},
		ft = { "blade", "php" }, -- optional, improves startup time
		opts = {
			-- This applies for nvim-cmp and coq, for blink refer to the configuration of this plugin
			close_tag_on_complete = true, -- default: true
		},
	},
	{
		"ta-tikoma/php.easy.nvim",
		config = true,
		keys = {
			{ "<leader>p#", "<CMD>PHPEasyAttribute<CR>", ft = "php", desc = "PHP: Add attribute" },
			{ "<leader>pb", "<CMD>PHPEasyDocBlock<CR>", ft = "php", desc = "PHP: Add DocBlock" },
			{ "<leader>pr", "<CMD>PHPEasyReplica<CR>", ft = "php", desc = "PHP: Replica" },
			{ "<leader>pc", "<CMD>PHPEasyCopy<CR>", ft = "php", desc = "PHP: Copy" },
			{ "<leader>pd", "<CMD>PHPEasyDelete<CR>", ft = "php", desc = "PHP: Delete" },
			{ "<leader>pi", "<CMD>PHPEasyInitInterface<CR>", ft = "php", desc = "PHP: Init interface" },
			{ "<leader>pc", "<CMD>PHPEasyInitClass<CR>", ft = "php", desc = "PHP: Init class" },
			{ "<leader>pac", "<CMD>PHPEasyInitAbstractClass<CR>", ft = "php", desc = "PHP: Init abstract class" },
			{ "<leader>pt", "<CMD>PHPEasyInitTrait<CR>", ft = "php", desc = "PHP: Init trait" },
			{ "<leader>pe", "<CMD>PHPEasyInitEnum<CR>", ft = "php", desc = "PHP: Init enum" },
			{
				"<leader>pc",
				"<CMD>PHPEasyAppendConstant<CR>",
				ft = "php",
				mode = { "n", "v" },
				desc = "PHP: Append constant",
			},
			{
				"<leader>pp",
				"<CMD>PHPEasyAppendProperty<CR>",
				ft = "php",
				mode = { "n", "v" },
				desc = "PHP: Append property",
			},
			{
				"<leader>pm",
				"<CMD>PHPEasyAppendMethod<CR>",
				ft = "php",
				mode = { "n", "v" },
				desc = "PHP: Append method",
			},
			{ "<leader>g_", "<CMD>PHPEasyAppendConstruct<CR>", ft = "php", desc = "PHP: Append constructor" },
		},
	},
	{
		"adalessa/laravel.nvim",
		event = { "VeryLazy" },
		config = true,
		dependencies = {
			"tpope/vim-dotenv",
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
			"kevinhwang91/promise-async",
		},
		cmd = { "Laravel" },
		keys = {
			{ "<leader>pla", ":Laravel artisan<cr>" },
			{ "<leader>pla", ":Laravel routes<cr>" },
		},
		opts = {},
	},
}
