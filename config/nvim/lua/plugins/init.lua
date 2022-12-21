local arch = vim.loop.os_uname()
local fzf_make_command = "make"
if arch == "arch64" then
	fzf_make_command = "arch -arch64 make"
end

return {
	{
		"sainnhe/everforest",
		config = function()
			vim.g.everforest_diagnostic_virtual_text = "colored"
			vim.g.everforest_enable_italic = 1
		end,
	},
	{ "tpope/vim-commentary", keys = { "gc" }, cmd = { "Commentary" } },
	{ "michaeljsmith/vim-indent-object", event = "BufReadPost" },
	{ "mechatroner/rainbow_csv", ft = "csv" },
	{ "tpope/vim-vinegar", keys = { "-" }, cmd = { "Explore" } },
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
			-- There's some type of fatal issue here but it'd be amazing if it got resolved
			-- { "nvim-telescope/telescope-fzf-writer.nvim" },
			-- { "nvim-telescope/telescope-file-browser.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = fzf_make_command },
		},
		init = function()
			require("config.telescope").keymaps()
		end,
		config = function()
			require("config.telescope").setup()
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "BufReadPost",
		config = function()
			require("nvim-surround").setup({
				-- move_cursor = false,
				-- surrounds = {
				-- 	["m"] = {
				-- 		add = { { "%{" }, { "}" } },
				-- 	},
				-- },
			})

			local surround_group = vim.api.nvim_create_augroup("zdcthomasSurroundGroup", { clear = true })

			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = { "markdown" },
				callback = function()
					surround.buffer_setup({
						surrounds = {
							["l"] = {
								add = function()
									local clipboard = vim.fn.getreg("+"):gsub("\n", "")
									return {
										{ "[" },
										{ "](" .. clipboard .. ")" },
									}
								end,
								find = "%b[]%b()",
								delete = "^(%[)().-(%]%b())()$",
								change = {
									target = "^()()%b[]%((.-)()%)$",
									replacement = function()
										local clipboard = vim.fn.getreg("+"):gsub("\n", "")
										return {
											{ "" },
											{ clipboard },
										}
									end,
								},
							},
						},
					})
				end,
				desc = "setup surround for eliixr",
			})
			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = { "lua" },
				callback = function()
					require("nvim-surround").buffer_setup({
						surrounds = {
							["F"] = {
								add = { "function () ", " end" },
							},
							["p"] = {
								add = { "vim.pretty_print(", ")" },
								find = "vim%.pretty_print%b()",
								delete = "^(vim%.pretty_print%()().-(%))()$",
								change = {
									target = "^(vim%.pretty_print%()().-(%))()$",
								},
							},
						},
					})
				end,
				desc = "setup surround for eliixr",
			})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = { "elixir" },
				callback = function()
					require("nvim-surround").buffer_setup({
						["m"] = {
							add = { { "%{" }, { "}" } },
						},
					})
				end,
				desc = "setup surround for eliixr",
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dev = false,
		build = ":TSUpdate",
		event = "BufReadPost",

		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"p00f/nvim-ts-rainbow",
			{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
		},
		config = function()
			require("config.treesitter").setup()
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
		"mhartington/formatter.nvim",
		-- Utilities for creating configurations
		cmd = { "FormatWrite", "Format" },
		dependencies = { "williamboman/mason.nvim" },
		init = function()
			vim.g.save_format = true
			vim.keymap.set("n", "<leader><leader>f", ":Format<CR>", { silent = true })

			local formatter_group = vim.api.nvim_create_augroup("formatter_group", { clear = true })

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				group = formatter_group,
				pattern = "*",
				callback = function()
					if vim.g.format_on_save then
						vim.cmd("FormatWrite")
					end
				end,
				desc = "Map q to close buffer",
			})
		end,
		config = function()
			require("config.formatter")
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		-- wants = { "LuaSnip" },
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind-nvim",
			"petertriho/cmp-git",
			{
				"L3MON4D3/LuaSnip",
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
		},
		config = function()
			-- See lspconfig comment on why this is in a function wrapper
			require("config.cmp").setup()
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
