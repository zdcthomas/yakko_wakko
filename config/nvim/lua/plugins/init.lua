--  --------------------------------------
--  |    Catch All For Random Plugins    |
--  --------------------------------------

return { -- { "danilamihailov/beacon.nvim", event = "VeryLazy" }, -- lazy calls setup() by itself
	-- {
	-- 	"AgusDOLARD/backout.nvim",
	-- 	opts = {},
	-- 	keys = {
	-- 		-- Define your keybinds
	-- 		{ "<M-b>", "<cmd>lua require('backout').back()<cr>", mode = { "i", "c" } },
	-- 		{ "<M-n>", "<cmd>lua require('backout').out()<cr>", mode = { "i", "c" } },
	-- 	},
	-- },
	{ "mechatroner/rainbow_csv", ft = "csv" },
	{
		"echasnovski/mini.splitjoin",
		version = false,
		keys = { {
			"gS",
			mode = { "x", "n" },
		} },
		config = function()
			require("mini.splitjoin").setup()
		end,
	},
	{ "rafcamlet/nvim-luapad", cmd = { "Luapad" }, dependencies = { "antoinemadec/FixCursorHold.nvim" } },
}
