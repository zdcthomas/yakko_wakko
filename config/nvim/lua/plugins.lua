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
-- * antoinemadec/FixCursorHold.nvim
-- * mattn/emmet-vim
-- * mbbill/undotree
-- * rbong/vim-buffest

function PluginIsLoaded(plugin_name)
	return packer_plugins[plugin_name] and packer_plugins[plugin_name].loaded
end

return require("packer").startup({
	function(use)
		use("antoinemadec/FixCursorHold.nvim")
		use("lewis6991/impatient.nvim")
		use("michaeljsmith/vim-indent-object")
		use("wbthomason/packer.nvim")
		use("MunifTanjim/nui.nvim")
		use("christoomey/vim-sort-motion", { keys = { "gs" } })

		use({
			"TimUntersberger/neogit",
			requires = "nvim-lua/plenary.nvim",
			config = function()
				local neogit = require("neogit")
				neogit.setup({})
			end,
		})

		-- Find and replace goodness
		use({
			"windwp/nvim-spectre",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			keys = { "<leader>S", "<leader>sw", "<leader>sf" },
			config = function()
				vim.keymap.set("n", "<leader>S", require("spectre").open)
				vim.keymap.set("n", "<leader>sw", function()
					require("spectre").open_visual({ select_word = true })
				end)
				vim.keymap.set("n", "<leader>sf", require("spectre").open_file_search)
			end,
		})
		use({ "kevinhwang91/nvim-bqf", ft = "qf" })
		use({ "seandewar/nvimesweeper", cmd = { "Nvimesweeper" } })
		use({ "tpope/vim-commentary", keys = { "gc" }, cmd = { "Commentary" } })
		use({
			"b0o/incline.nvim",
			config = function()
				require("incline").setup({
					highlight = {
						groups = {
							InclineNormal = "PmenuSel",
							InclineNormalNC = "PmenuSbar",
						},
					},
					hide = {
						focused_win = false,
					},
				})
			end,
		})

		use({
			"stevearc/dressing.nvim",
			config = config.dressing,
		})

		use({
			"takac/vim-hardtime",
			cmd = {
				"HardTimeOff",
				"HardTimeToggle",
				"HardTimeOn",
			},
			config = config.hardtime,
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

		use({
			"rose-pine/neovim",
			as = "rose-pine",
			config = config.rose_pine,
		})

		-- use({
		-- 	"https://gitlab.com/yorickpeterse/nvim-pqf.git",
		-- 	config = function()
		-- 		require("pqf").setup()
		-- 	end,
		-- })

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
			"L3MON4D3/LuaSnip",
			-- requires = { "hrsh7th/vim-vsnip-integ" },
			config = function()
				require("config.luasnip")
			end,
		})

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
				"L3MON4D3/LuaSnip",
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
			config = function()
				require("config.lualine").setup()
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = require("config.gitsigns"),
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
				-- "ckipp01/stylua-nvim",
				"hrsh7th/nvim-cmp",
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
			"segeljakt/vim-silicon",
			cmd = { "Silicon" },
		})

		use({
			"nvim-neorg/neorg",
			config = require("config.neorg").setup,
			requires = {
				"nvim-lua/plenary.nvim",
				"~/dev/neorg-telescope",
			},
		})

		use({
			"anuvyklack/hydra.nvim",
			requires = "anuvyklack/keymap-layer.nvim", -- needed only for pink hydras
			config = function()
				local Hydra = require("hydra")
				Hydra({
					name = "Side scroll",
					mode = "n",
					body = "z",
					heads = {
						{ "h", "5zh" },
						{ "l", "5zl", { desc = "←/→" } },
						{ "H", "zH" },
						{ "L", "zL", { desc = "half screen ←/→" } },
					},
				})

				local function open_or_move(direction)
					local current_window = vim.fn.winnr()
					vim.api.nvim_exec("wincmd " .. direction, false)

					if current_window == vim.api.nvim_eval("winnr()") then
						if vim.tbl_contains({ "j", "k" }, direction) then
							vim.api.nvim_exec("wincmd s", false)
						else
							vim.api.nvim_exec("wincmd v", false)
						end

						vim.api.nvim_exec("wincmd " .. direction, false)
					end
				end

				Hydra({
					config = {
						color = "pink",
						invoke_on_body = true,
					},
					name = "windows n stuff",
					mode = "n",
					body = "<leader><leader>w",
					heads = {
						{ "L", "<c-w>L" },
						{ "J", "<c-w>J" },
						{ "K", "<c-w>K" },
						{ "H", "<c-w>H" },

						{
							"l",
							function()
								open_or_move("l")
							end,
						},
						{
							"k",
							function()
								open_or_move("k")
							end,
						},
						{
							"j",
							function()
								open_or_move("j")
							end,
						},
						{
							"h",
							function()
								open_or_move("h")
							end,
						},

						{ "<c-j>", ":vsp<CR>" },
						{ "<c-l>", ":sp<CR>" },

						{ "n", ":vnew<CR>" },
						{ "o", "<c-w>o" },
						{ "=", "<c-w>=" },

						{ "w", ":w<cr>" },
						{ "q", ":q<cr>" },
					},
				})
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
