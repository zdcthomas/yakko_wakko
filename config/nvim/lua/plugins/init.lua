--  --------------------------------------
--  |    Catch All For Random Plugins    |
--  --------------------------------------

return {
	{
		"lukas-reineke/indent-blankline.nvim",
		-- lazy = false,
		-- cmd = "VeryLazy",
		lazy = false,
		config = function()
			require("indent_blankline").setup({
				-- for example, context is off by default, use this to turn it on
				-- show_current_context = true,
				-- show_current_context_start = true,
				-- buftype_exclude = { "terminal", "nofile", "quickfix", "prompt" },
				filetype_exclude = {
					"lspinfo",
					"packer",
					"checkhealth",
					"help",
					"man",
					"",
					"startify",
					"help",
					"startify",
					"dashboard",
					"packer",
					"neogitstatus",
					"NvimTree",
					"Trouble",
				},
			})
		end,
	},
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
		"AckslD/muren.nvim",
		cmd = {
			"MurenToggle",
			"MurenOpen",
			"MurenClose",
			"MurenFresh",
			"MurenUnique",
		},
		config = true,
	},
	{
		"luukvbaal/stabilize.nvim",
		event = "VeryLazy",
		config = function()
			require("stabilize").setup()
		end,
	},
	{
		url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
		ft = "qf",
		config = function(opts)
			require("pqf").setup()
		end,
	},
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
	{
		"mattn/emmet-vim",
		ft = { "html", "js", "ts", "tsx", "typescriptreact" },
		config = function()
			vim.g.user_emmet_mode = "a"
		end,
	},
	{
		"Bekaboo/dropbar.nvim",
		init = function()
			vim.keymap.set("n", "<cr>", require("dropbar.api").pick, {})
		end,
	},
	{
		"ruifm/gitlinker.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			"<leader>gy",
		},
		config = function()
			require("gitlinker").setup()
		end,
	},
	{ "mechatroner/rainbow_csv", ft = "csv" },

	{
		"codethread/qmk.nvim",
		cmd = { "QMKFormat" },
		config = function()
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
