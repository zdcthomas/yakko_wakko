--  --------------------------------------
--  |    Catch All For Random Plugins    |
--  --------------------------------------

return {
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
		config = function()
			require("pqf").setup()
		end,
	},
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
	{
		"mattn/emmet-vim",
		ft = { "html", "js", "ts" },
		config = function()
			vim.g.user_emmet_mode = "a"
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
	{
		"sainnhe/everforest",
		priority = 1000,
		lazy = false,
		config = function()
			vim.g.everforest_diagnostic_virtual_text = "colored"
			vim.g.everforest_enable_italic = 1
			vim.cmd.colorscheme("everforest")
		end,
	},
	{ "mechatroner/rainbow_csv", ft = "csv" },
	{ "tpope/vim-vinegar", keys = { "-" }, cmd = { "Explore" } },
}
