return {
	{
		"sainnhe/everforest",
		config = function()
			vim.g.everforest_diagnostic_virtual_text = "colored"
			vim.g.everforest_enable_italic = 1
		end,
	},
	{ "tpope/vim-commentary" },
	{ "michaeljsmith/vim-indent-object", event = "BufReadPost" },
	{ "mechatroner/rainbow_csv", ft = "csv" },
	{ "tpope/vim-vinegar", keys = { "-" }, cmd = { "Explore" } },
	{
		"folke/zen-mode.nvim",
		cmd = {
			"ZenMode",
		},
		config = function()
			require("zen-mode").setup({
				window = {
					width = 135,
					backdrop = 1,
				},
			})
		end,
	},

	{
		"williamboman/mason.nvim",
		-- requires = { "williamboman/mason-lspconfig.nvim" },
		cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUninstall", "MasonUninstallAll" },
		config = function()
			require("mason").setup()
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		config = function()
			require("config.luasnip")
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("config.general").autopairs()
		end,
	},
	{
		"mhinz/vim-startify",
		branch = "center",
		config = function()
			require("config.startify").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = require("config.gitsigns").setup,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPost",
		dependencies = {
			"weilbith/nvim-code-action-menu",
			"j-hui/fidget.nvim",
			"hrsh7th/nvim-cmp",
			"kosayoda/nvim-lightbulb",
			"nvim-telescope/telescope.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"simrat39/rust-tools.nvim",
			{
				"folke/neodev.nvim",
				ft = "lua",
			},
		},
		config = function()
			require("fidget").setup({})
			-- Ok I really don't understand this. If I remove this function
			-- wrapper, then any local function defined within config/lspconfig
			-- won't be usable by the setup function. This makes no sense.
			require("config.lspconfig").setup()
		end,
	},
}
