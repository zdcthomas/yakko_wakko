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
	-- { "tpope/vim-sleuth", event = { "VeryLazy" } },
	{
		"rafcamlet/nvim-luapad",
		cmd = { "Luapad" },
		dependencies = { "antoinemadec/FixCursorHold.nvim" },
		opts = {
			eval_on_change = false,
			eval_on_move = true,
		},
	},
	{
		"terrastruct/d2-vim",
		ft = { "d2" },
	},
	-- bad dog no biscuits, overwrote j and k and bricked me.
	-- Banned from the mickey mouse club house
	-- {
	-- 	"LuxVim/nvim-luxmotion",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("luxmotion").setup({
	-- 			cursor = {
	-- 				duration = 250,
	-- 				easing = "ease-out",
	-- 				enabled = true,
	-- 			},
	-- 			scroll = {
	-- 				duration = 400,
	-- 				easing = "ease-out",
	-- 				enabled = true,
	-- 			},
	-- 			performance = { enabled = false },
	-- 			keymaps = {
	-- 				cursor = true,
	-- 				scroll = true,
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
