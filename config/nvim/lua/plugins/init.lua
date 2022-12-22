return {
	{
		"luukvbaal/stabilize.nvim",
		event = "VeryLazy",
		config = function()
			require("stabilize").setup()
		end,
	},
	{
		"stevearc/dressing.nvim",
		event = "BufReadPost",
		config = function()
			require("dressing").setup({
				input = {
					enabled = true,
					default_prompt = "➤ ",
					insert_only = false,

					-- These are passed to nvim_open_win
					anchor = "SW",
					relative = "cursor",
					border = "rounded",
				},
				select = {
					enabled = true,
					backend = { "builtin", "telescope", "nui" },
				},
			})
		end,
	},
	{
		"sainnhe/everforest",
		lazy = true,
		config = function()
			vim.g.everforest_diagnostic_virtual_text = "colored"
			vim.g.everforest_enable_italic = 1
		end,
	},
	{ "tpope/vim-commentary", event = "BufReadPost" },
	{ "michaeljsmith/vim-indent-object", event = "BufReadPost" },
	{ "mechatroner/rainbow_csv", ft = "csv" },
	{ "tpope/vim-vinegar", keys = { "-" }, cmd = { "Explore" } },
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			require("notify").setup({
				stages = "slide",
				timeout = 3000,
				-- Minimum width for notification windows
				minimum_width = 30,
				icons = {
					ERROR = "",
					WARN = "",
					INFO = "",
					DEBUG = "",
					TRACE = "✎",
				},
			})
			vim.notify = require("notify")
		end,
	},
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
		"nicwest/vim-camelsnek",
		cmd = { "Snek", "Pascal", "Camel", "Kebab" },
		init = function()
			vim.g.camelsnek_alternative_camel_commands = 1

			vim.keymap.set("n", "crs", ":Snek<CR>", { silent = true, desc = "snake_case" })
			vim.keymap.set("x", "crs", ":Snek<CR>", { silent = true, desc = "snake_case" })

			vim.keymap.set("n", "crp", ":Pascal<CR>", { silent = true, desc = "PascalCase" })
			vim.keymap.set("x", "crp", ":Pascal<CR>", { silent = true, desc = "PascalCase" })

			vim.keymap.set("n", "crc", ":Camel<CR>", { silent = true, desc = "camelCase" })
			vim.keymap.set("x", "crc", ":Camel<CR>", { silent = true, desc = "camel_case" })

			vim.keymap.set("n", "crk", ":Kebab<CR>", { silent = true, desc = "kebab-case" })
			vim.keymap.set("x", "crk", ":Kebab<CR>", { silent = true, desc = "kebab-case" })
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
