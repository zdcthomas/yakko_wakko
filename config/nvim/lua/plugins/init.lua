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
		"Julian/vim-textobj-variable-segment",
		event = "BufReadPost",
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
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
	{ "tpope/vim-commentary", event = "BufReadPost" },
	{ "michaeljsmith/vim-indent-object", event = "BufReadPost" },
	{ "mechatroner/rainbow_csv", ft = "csv" },
	{ "tpope/vim-vinegar", keys = { "-" }, cmd = { "Explore" } },
	{
		"williamboman/mason.nvim",
		-- requires = { "williamboman/mason-lspconfig.nvim" },
		cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUninstall", "MasonUninstallAll" },
		config = function()
			require("mason").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				fast_wrap = {},
				check_ts = true,
				disable_in_macro = true,
			})
		end,
	},
}
