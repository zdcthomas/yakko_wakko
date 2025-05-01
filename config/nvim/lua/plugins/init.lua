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
	{ "rafcamlet/nvim-luapad", cmd = { "Luapad" }, dependencies = { "antoinemadec/FixCursorHold.nvim" } },
	{ "meznaric/key-analyzer.nvim", opts = {}, cmd = { "KeyAnalyzer" } },
	{
		"bassamsdata/namu.nvim",
		keys = {

			{
				"<leader>Ns",
				":Namu symbols<cr>",
				{
					desc = "Jump to LSP symbol",
					silent = true,
				},
			},
		},
		cmd = { "Namu" },
		config = function()
			require("namu").setup({
				-- Enable the modules you want
				namu_symbols = {
					enable = true,
					options = {}, -- here you can configure namu
				},
				-- Optional: Enable other modules if needed
				ui_select = { enable = false }, -- vim.ui.select() wrapper
				colorscheme = {
					enable = false,
					options = {
						-- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
						persist = true, -- very efficient mechanism to Remember selected colorscheme
						write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
					},
				},
			})
			-- === Suggested Keymaps: ===
		end,
	},
}
