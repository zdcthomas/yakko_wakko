return {
	{
		"windwp/nvim-spectre",
		cmd = "Spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		init = function()
			vim.keymap.set("n", "<leader>sp", function()
				require("spectre").open()
			end, {})
			vim.keymap.set("x", "<leader>sp", function()
				require("spectre").open_visual({ select_word = true })
			end, {})
			vim.keymap.set("n", "<leader>sfp", function()
				require("spectre").open_file_search()
			end, {})
		end,
		config = function()
			require("spectre").setup()
		end,
	},
	{
		"MagicDuck/grug-far.nvim",
		cmd = {
			"GrugFar",
		},
		opts = {},
	},
}
