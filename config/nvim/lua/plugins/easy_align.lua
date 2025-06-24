return {
	-- {
	-- 	"junegunn/vim-easy-align",
	-- 	keys = {
	-- 		{ "ga", "<Plug>(EasyAlign)", mode = { "x", "n" } },
	-- 	},
	-- },
	{
		"echasnovski/mini.align",
		version = false,
		keys = { "ga", "gA" },
		config = function()
			require("mini.align").setup()
		end,
	},
	-- {
	-- 	"echasnovski/mini.align",

	-- 	config = function()
	-- 		require("mini.align").setup()
	-- 	end,
	-- 	keys = {
	-- 		{ "ga",    mode = "n" },
	-- 		{      "ga", mode = "x" },
	-- 	},
	-- },
}
