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
		use({
			"~/oss/yop.nvim/",
			config = function()
				local yop = require("yop")
				local utils = require("yop.utils")

				yop.op_map({ "n", "v" }, "<leader><leader>b", function(lines, info)
					return { "bread" }
				end)

				yop.op_map({ "n", "v" }, "<leader><leader>gs", function(lines, opts)
					-- We don't care about anything non alphanumeric here
					local sort_without_leading_space = function(a, b)
						-- true = a then b
						-- false = b then a
						local pattern = [[^%W*]]
						return string.gsub(a, pattern, "") < string.gsub(b, pattern, "")
					end
					if #lines == 1 then
						-- If only looking at 1 line, sort that line split by some char gotten from imput
						local delimeter = utils.get_input("Delimeter: ")
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
		use("christoomey/vim-sort-motion", { keys = { "gs" } })
		use({
			-- The only downside I've found to this vs sandwich is that tags don't have
			-- the same nice syntax and the
			"tpope/vim-surround",
			requires = {
				"https://github.com/tpope/vim-repeat",
				{
					"AndrewRadev/dsf.vim",
					config = function()
						vim.g.dsf_brackets = "("
					end,
				},
			},
			config = function()
				local surround_group = vim.api.nvim_create_augroup("Zurround", { clear = true })

				vim.api.nvim_create_autocmd("FileType", {
					group = surround_group,
					pattern = { "lua" },
					callback = function()
						vim.cmd([[ let b:surround_{char2nr('F')} = "function()\n \r \nend" ]])
					end,
				})

				vim.api.nvim_create_autocmd("FileType", {
					group = surround_group,
					pattern = { "elixir" },
					callback = function()
						vim.cmd([[ let b:surround_{char2nr('m')} = "%{ \r }" ]])
					end,
				})

				vim.api.nvim_create_autocmd("FileType", {
					group = surround_group,
					pattern = { "lua" },
					callback = function()
						vim.cmd([[ let b:surround_{char2nr('g')} = "\1Generic: \1<\r>" ]])
					end,
				})
			end,
		})
		use({
			"folke/lua-dev.nvim",
			module = "lua-dev",
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
		use({ "folke/tokyonight.nvim" })

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

		-- use({
		-- 	"machakann/vim-sandwich",
		-- 	config = function()
		-- 		require("config.sandwich").setup()
		-- 		-- vim.cmd([[
		-- 		-- exec 'source ' . "~/.vim/settings/plugins/sandwich_settings.vim"
		-- 		-- ]])
		-- 	end,
		-- })

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
				-- There's some type of fatal issue here but it'd be amazing if it got resolved
				{ "nvim-telescope/telescope-fzf-writer.nvim" },
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
			"nvim-lua/plenary.nvim",
			config = function()
				local plen_group = vim.api.nvim_create_augroup("PlenaryGroupBindings", { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = plen_group,
					pattern = { "lua" },
					callback = function()
						vim.keymap.set("n", "<leader><leader>t", "<Plug>PlenaryTestFile", { buffer = true })
					end,
				})
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
			"mhartington/formatter.nvim",
			-- Utilities for creating configurations
			config = function()
				vim.keymap.set("n", "<leader><leader>f", ":Format<CR>", { silent = true })
				local util = require("formatter.util")

				-- Provides the Format and FormatWrite commands
				require("formatter").setup({
					-- Enable or disable logging
					logging = true,
					-- Set the log level
					log_level = vim.log.levels.WARN,
					-- All formatter configurations are opt-in
					filetype = {
						-- Formatter configurations for filetype "lua" go here
						-- and will be executed in order
						lua = {
							require("formatter.filetypes.lua").stylua,
						},
					},
				})
			end,
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
			"nvim-orgmode/orgmode",
			config = function()
				require("orgmode").setup_ts_grammar()
				require("orgmode").setup({
					org_agenda_files = { "~/irulan/org/*", "~/my-orgs/**/*" },
					org_default_notes_file = "~/irulan/org/refile.org",
				})
			end,
		})

		use({
			"anuvyklack/hydra.nvim",
			requires = "anuvyklack/keymap-layer.nvim", -- needed only for pink hydras
			config = function()
				require("config.hydra").setup()
			end,
		})

		-- use("neovim/nvimdev.nvim")

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
