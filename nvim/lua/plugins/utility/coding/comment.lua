return {
	-- gcc -> current line
	-- gbc -> block
	"numToStr/Comment.nvim",
	lazy = false,
	enabled = true,
	config = function()
		require("Comment").setup()
	end,
}
