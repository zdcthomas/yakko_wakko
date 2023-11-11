--  --------------------------------------
--  |    Catch All For Random Plugins    |
--  --------------------------------------

return {
	{
		"echasnovski/mini.splitjoin",
		version = false,
		keys = { {
			"gS",
			mode = { "n", "x" },
		} },
		config = function()
			require("mini.splitjoin").setup()
		end,
	},
	{
		"uga-rosa/ccc.nvim",
		ft = {
			"lua",
			"css",
			"js",
			"ts",
			"jsx",
			"tsx",
		},
		cmd = {
			"CccPick",
			"CccConvert",
			"CccHighlighterToggle",
			"CccHighlighterEnable",
			"CccHighlighterDisable",
		},
		opts = {
			highlighter = {
				auto_enable = true,
				lsp = true,
				excludes = { "lazy", "mason", "help", "neo-tree" },
			},
		},
	},
	{
		"luukvbaal/stabilize.nvim",
		event = "VeryLazy",
		config = function()
			require("stabilize").setup()
		end,
	},
	{
		"mattn/emmet-vim",
		ft = { "html", "js", "ts", "tsx", "typescriptreact" },
		config = function()
			vim.g.user_emmet_mode = "a"
		end,
	},
	{ "mechatroner/rainbow_csv", ft = "csv" },
	{
		"codethread/qmk.nvim",
		cmd = { "QMKFormat" },
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("qmk").setup({
				name = "LAYOUT_preonic_grid", -- identify your layout name
				comment_preview = {
					keymap_overrides = {
						HERE_BE_A_LONG_KEY = "Magic", -- replace any long key codes
					},
				},
				-- layout = { -- create a visual representation of your final layout
				-- 	"x ^xx", -- including keys that span multple rows (with alignment left, center or right)
				-- 	"_ x x", -- pad empty cells
				-- 	"_ x x",
				-- },
			})
		end,
	},
}
