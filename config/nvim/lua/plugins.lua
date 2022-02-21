local execute = vim.api.nvim_command
local config = require("config.general")

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

-- potential plugins
-- * mzlogin/vim-markdown-toc
-- * antoinemadec/FixCursorHold.nvim
-- * mattn/emmet-vim
-- * mbbill/undotree

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")
		use("michaeljsmith/vim-indent-object")
		use("MunifTanjim/nui.nvim")
		use({ "seandewar/nvimesweeper", cmd = { "Nvimesweeper" } })
		use({ "kevinhwang91/nvim-bqf", ft = "qf" })
		use({ "tpope/vim-commentary", keys = { "gc" }, cmd = { "Commentary" } })

		use({
			"~/dev/wiki.vim",
			config = function()
				vim.g.wiki_root = "~/irulan"
				vim.g.wiki_filetypes = { "md" }
				vim.g.wiki_link_extension = ".md"
				vim.g.wiki_link_target_type = "md"

				vim.g.wiki_journal = {
					name = "watashi_no_nikki",
					frequency = "daily",
					date_format = {
						daily = "%Y-%m-%d",
						weekly = "%Y_w%V",
						monthly = "%Y_m%m",
					},
				}
			end,
		})

		use({
			"folke/zen-mode.nvim",
			config = function()
				require("zen-mode").setup({
					-- your configuration comes here
					-- or leave it empty to use the default settings
					-- refer to the configuration section below
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
			"rose-pine/neovim",
			as = "rose-pine",
			config = config.rose_pine,
		})

		use({
			"https://gitlab.com/yorickpeterse/nvim-pqf.git",
			config = function()
				require("pqf").setup()
			end,
		})

		use({
			"machakann/vim-sandwich",
			config = function()
				vim.cmd([[
          exec 'source ' . "~/.vim/settings/plugins/sandwich_settings.vim"
        ]])
			end,
		})

		use({
			"windwp/nvim-autopairs",
			on = "InsertEnter",
			config = config.autopairs,
		})

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-calc",
				"petertriho/cmp-git",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-vsnip",
				"onsails/lspkind-nvim",
				{
					"hrsh7th/vim-vsnip",
					requires = { "hrsh7th/vim-vsnip-integ" },
					config = function()
						vim.g.vsnip_snippet_dir = "~/yakko_wakko/config/nvim/snippets"
					end,
				},
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
			requires = {
				{ "nvim-lua/lsp-status.nvim" },
			},
			config = config.lualine,
		})

		use({
			"lewis6991/gitsigns.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = config.git_signs,
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
			keys = {
				"<Leader>p",
				"<Leader>q",
				"<Leader>n",
				"<Leader>b",
				"<Leader>F",
				"<Leader>*",
				"<Leader>wp",
				"<Leader><Leader>q",
				"<Leader>ca",
				"<Leader>/",
				"gd",
			},
			cmd = { "Telescope" },
			requires = {
				{ "nvim-lua/popup.nvim" },
				{ "nvim-lua/plenary.nvim" },
				{
					"kyazdani42/nvim-web-devicons",
					config = function()
						require("nvim-web-devicons").setup({
							default = true,
						})
					end,
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },
				{ "nvim-telescope/telescope-file-browser.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
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
			"neovim/nvim-lspconfig",
			requires = {
				-- config handled in config.lspconfig
				"ckipp01/stylua-nvim",
				"hrsh7th/nvim-cmp",
				"hrsh7th/vim-vsnip",
				"kosayoda/nvim-lightbulb",
				"nvim-lua/lsp-status.nvim",
				"nvim-telescope/telescope.nvim",
				"ray-x/lsp_signature.nvim",
				"williamboman/nvim-lsp-installer",
			},
			config = function()
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
			"justinmk/vim-dirvish",
			requires = {
				"kristijanhusak/vim-dirvish-git",
				"roginfarrer/vim-dirvish-dovish",
			},
			config = config.dirvish,
		})

		use({
			"renerocksai/telekasten.nvim",
			after = "telescope.nvim",
			config = function()
				require("config.telekasten").setup()
			end,
		})

		use({
			"segeljakt/vim-silicon",
			cmd = { "Silicon" },
		})
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
