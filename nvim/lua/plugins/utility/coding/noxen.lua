return {
	"r7sqtr/noxen.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"folke/snacks.nvim", -- or "nvim-telescope/telescope.nvim"
		"nvim-tree/nvim-web-devicons", -- optional
	},
	opts = {
		notes_dir = "~/.noxen",
		template = "default.md",
		ui = {
			position = "center", -- "center", "bottom", "right"
			width = "80%", -- number or "%"
			height = "80%", -- number or "%"
			border = "rounded",
			auto_save = true,
		},
		search = {
			engine = "snacks", -- "snacks" or "telescope"
		},
	},
	cmd = {
		"NoxenNew",
		"NoxenFind",
		"NoxenGrep",
		"NoxenTags",
		"NoxenProjects",
		"NoxenToggle",
		"NoxenQuick",
	},
	keys = {
		{ "<leader>mn", "<cmd>NoxenNew<cr>", desc = "Noxen: New Note" },
		{ "<leader>mf", "<cmd>NoxenFind<cr>", desc = "Noxen: Find Notes" },
		{ "<leader>mg", "<cmd>NoxenGrep<cr>", desc = "Noxen: Grep Notes" },
		{ "<leader>mt", "<cmd>NoxenTags<cr>", desc = "Noxen: Search by Tag" },
		{ "<leader>mp", "<cmd>NoxenProjects<cr>", desc = "Noxen: Switch Project" },
		{ "<leader>mo", "<cmd>NoxenToggle<cr>", desc = "Noxen: Toggle Note" },
		{ "<leader>mq", "<cmd>NoxenQuick<cr>", desc = "Noxen: Quick Note" },
	},
}
