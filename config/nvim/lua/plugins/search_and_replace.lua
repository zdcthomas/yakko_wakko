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

	-- {
	-- 	"cshuaimin/ssr.nvim",
	-- 	-- Calling setup is optional.
	-- 	keys = {
	-- 		{
	-- 			"<leader>sr",
	-- 			function()
	-- 				require("ssr").open()
	-- 			end,
	-- 		},
	-- 	},
	-- 	opts = {
	-- 		border = "rounded",
	-- 		min_width = 50,
	-- 		min_height = 5,
	-- 		max_width = 120,
	-- 		max_height = 25,
	-- 		adjust_window = true,
	-- 		keymaps = {
	-- 			close = "q",
	-- 			next_match = "n",
	-- 			prev_match = "N",
	-- 			replace_confirm = "<cr>",
	-- 			replace_all = "<leader><cr>",
	-- 		},
	-- 	},
	-- },

	{
		"MagicDuck/grug-far.nvim",
		cmd = {
			"GrugFar",
		},
		opts = {},
	},
}
