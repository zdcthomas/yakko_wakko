return {
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "x" } },
			{ "gb", mode = { "n", "x" } },
			{ "gcA", mode = { "n", "x" } },
			{ "gco", mode = { "n", "x" } },
			{ "gcO", mode = { "n", "x" } },
		},
		config = function()
			require("Comment").setup()
		end,
	},
	-- {
	-- 	"tpope/vim-commentary",
	-- 	keys = {
	-- 		{ "gc", mode = { "n", "x" } },
	-- 	},
	-- },
}
