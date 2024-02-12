--  --------------------------------------
--  |    Catch All For Random Plugins    |
--  --------------------------------------

return {
	{
		"chrisgrieser/nvim-scissors",
		init = function()
			vim.keymap.set("n", "<leader>Se", function()
				require("scissors").editSnippet()
			end)

			-- When used in visual mode prefills the selection as body.
			vim.keymap.set({ "n", "x" }, "<leader>Sa", function()
				require("scissors").addNewSnippet()
			end)
		end,
		dependencies = "nvim-telescope/telescope.nvim", -- optional
		opts = {
			snippetDir = "~/yakko_wakko/config/nvim/snippets",
		},
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
