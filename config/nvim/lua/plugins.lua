local config = require("config.general")
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

-- potential plugins
-- * mzlogin/vim-markdown-toc
-- * mbbill/undotree
-- * rbong/vim-buffest

function PluginIsLoaded(plugin_name)
	return packer_plugins and packer_plugins[plugin_name] and packer_plugins[plugin_name].loaded
end

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")
		use("mechatroner/rainbow_csv")
		use({
			"theblob42/drex.nvim",
			requires = "kyazdani42/nvim-web-devicons", -- optional
			config = function()
				require("config.drex")
			end,
		})
		use({
			"shaunsingh/nord.nvim",
			wants = "nvim-treesitter/nvim-treesitter",
			config = function()
				vim.g.nord_borders = true
				vim.g.nord_italic = true
				vim.g.nord_uniform_diff_background = true
			end,
		})

		use("antoinemadec/FixCursorHold.nvim")
		-- use("lewis6991/impatient.nvim")
		use("michaeljsmith/vim-indent-object")
		use({
			"mattn/emmet-vim",
			config = function()
				vim.g.user_emmet_mode = "a"
			end,
		})

		use({
			"kylechui/nvim-surround",
			tag = "*", -- Use for stability; omit to use `main` branch for the latest features
			config = function()
				require("nvim-surround").setup({
					move_cursor = false,
					-- surrounds = {
					-- 	["m"] = {
					-- 		add = { { "%{" }, { "}" } },
					-- 	},
					-- },
				})
			end,
		})

		use({
			"protex/home-manager.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = function() end,
		})

		use({
			"zdcthomas/yop.nvim",
			config = function()
				local yop = require("yop")
				local utils = require("yop.utils")
				yop.op_map({ "n", "v" }, "gs", function(lines, _)
					-- We don't care about anything non alphanumeric here
					local sort_without_leading_space = function(a, b)
						-- true = a then b
						-- false = b then a
						local pattern = [[^%W*]]
						return string.gsub(a, pattern, "") < string.gsub(b, pattern, "")
					end
					if #lines == 1 then
						-- local delimeter = utils.get_input("Delimeter: ")
						local delimeter = ","
						local split = vim.split(lines[1], delimeter, { trimempty = true })
						-- Remember! `table.sort` mutates the table itself
						table.sort(split, sort_without_leading_space)
						return { utils.join(split, delimeter) }
					else
						-- If there are many lines, sort the lines themselves
						table.sort(lines, sort_without_leading_space)
						return lines
					end
				end)
			end,
		})

		-- use("christoomey/vim-sort-motion", { keys = { "gs" } })

		use({
			"folke/neodev.nvim",
			module = "neodev",
		})

		-- Find and replace goodness
		use({
			"windwp/nvim-spectre",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			keys = { "<leader>S", "<leader>sw", "<leader>sf" },
			config = function()
				vim.keymap.set("n", "<leader>S", require("spectre").open, {})
				vim.keymap.set("n", "<leader>sw", function()
					require("spectre").open_visual({ select_word = true })
				end, {})
				vim.keymap.set("n", "<leader>sf", require("spectre").open_file_search, {})
			end,
		})

		use({
			"luukvbaal/stabilize.nvim",
			config = function()
				require("stabilize").setup()
			end,
		})

		use({ "kevinhwang91/nvim-bqf", ft = "qf" })
		use({ "seandewar/nvimesweeper", cmd = { "Nvimesweeper" } })
		use({ "tpope/vim-commentary", keys = { "gc" }, cmd = { "Commentary" } })
		use({
			"stevearc/dressing.nvim",
			config = config.dressing,
		})

		use({
			"folke/zen-mode.nvim",
			cmd = {
				"ZenMode",
			},
			module = "zen-mode",
			config = function()
				require("zen-mode").setup({
					window = {
						width = 135,
						backdrop = 1,
					},
				})
			end,
		})

		use({
			"jbyuki/venn.nvim",
			keys = { "<Leader>v" },
			config = config.venn,
		})

		use({
			"rcarriga/nvim-notify",
			config = config.notify,
		})

		use({
			"nicwest/vim-camelsnek",
			config = config.camelsnek,
		})

		use({
			"dhruvasagar/vim-table-mode",
			cmd = { "TableModeToggle" },
		})

		use({
			"Julian/vim-textobj-variable-segment",
			requires = {
				"kana/vim-textobj-user",
			},
		})

		use({
			"rebelot/kanagawa.nvim",
			config = config.kanagawa,
		})

		use({ "folke/tokyonight.nvim" })

		use({
			"rose-pine/neovim",
			as = "rose-pine",
			config = config.rose_pine,
		})

		use({
			"windwp/nvim-autopairs",
			on = "InsertEnter",
			config = config.autopairs,
		})

		local luasnip_config = {
			"L3MON4D3/LuaSnip",
			tag = "v1.*",
			config = function()
				require("config.luasnip")
			end,
		}
		use(luasnip_config)

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-calc",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"saadparwaiz1/cmp_luasnip",
				"onsails/lspkind-nvim",
				"petertriho/cmp-git",
				luasnip_config,
			},
			config = function()
				-- See lspconfig comment on why this is in a function wrapper
				require("config.cmp").setup()
			end,
		})

		use({
			"kyazdani42/nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup({
					default = true,
				})
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			config = function()
				require("config.lualine").setup()
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = require("config.gitsigns").setup,
		})

		use({
			"junegunn/vim-easy-align",
			keys = {
				{ "x", "ga" },
				{ "n", "ga" },
			},
			cmd = "EasyAlign",
			config = config.easy_align,
		})

		use({
			"mhinz/vim-startify",
			branch = "center",
			config = function()
				require("config.startify").setup()
			end,
		})

		use({
			"nvim-telescope/telescope.nvim",
			requires = {
				{ "nvim-lua/popup.nvim" },
				{ "nvim-lua/plenary.nvim" },
				{ "kyazdani42/nvim-web-devicons" },
				{ "nvim-telescope/telescope-ui-select.nvim" },
				-- There's some type of fatal issue here but it'd be amazing if it got resolved
				-- { "nvim-telescope/telescope-fzf-writer.nvim" },
				-- { "nvim-telescope/telescope-file-browser.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "arch -arm64 make" },
			},
			config = function()
				require("config.telescope").setup()
			end,
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			requires = {
				"p00f/nvim-ts-rainbow",
				{
					"nvim-treesitter/playground",
					cmd = "TSPlaygroundToggle",
				},
			},
			config = function()
				require("config.treesitter").setup()
			end,
		})

		use({
			"williamboman/mason.nvim",
			requires = { "williamboman/mason-lspconfig.nvim" },
			config = function()
				require("mason").setup()
			end,
		})

		use({
			"neovim/nvim-lspconfig",
			requires = {
				"weilbith/nvim-code-action-menu",
				"j-hui/fidget.nvim",
				"hrsh7th/nvim-cmp",
				"kosayoda/nvim-lightbulb",
				"nvim-telescope/telescope.nvim",
				"williamboman/mason.nvim",
			},
			config = function()
				require("fidget").setup({})
				-- Ok I really don't understand this. If I remove this function
				-- wrapper, then any local function defined within config/lspconfig
				-- won't be usable by the setup function. This makes no sense.
				require("config.lspconfig").setup()
			end,
		})

		use({
			"ruifm/gitlinker.nvim",
			requires = "nvim-lua/plenary.nvim",
			keys = {
				"<leader>gy",
			},
			config = function()
				require("gitlinker").setup()
			end,
		})

		use({
			"segeljakt/vim-silicon",
			cmd = { "Silicon" },
		})

		use({
			"mhartington/formatter.nvim",
			-- Utilities for creating configurations
			config = function()
				require("config.formatter")
			end,
		})

		use({
			"nvim-neorg/neorg",
			ft = "norg",
			cmd = "Neorg",
			after = "nvim-treesitter", -- You may want to specify Telescope here as well
			config = function()
				-- command to enable parsers sync
				-- CC=/usr/local/Cellar/gcc/11.2.0_3/bin/gcc-11 nvim
				require("config.neorg").setup()
			end,
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-neorg/neorg-telescope",
				"max397574/neorg-kanban",
			},
		})

		use({
			"anuvyklack/hydra.nvim",
			config = function()
				require("config.hydra").setup()
			end,
		})

		if packer_bootstrap then
			require("packer").sync()
		end
	end,
	config = {
		compile_path = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua",
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
		profile = {
			enable = true,
		},
	},
})
