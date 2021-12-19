local execute = vim.api.nvim_command
local config = require("config.general")

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
	execute("packadd packer.nvim")
end

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")
		use("michaeljsmith/vim-indent-object")
		use("wellle/targets.vim")

		-- use({ "tpope/vim-unimpaired", cmd = { "Unimpared" } })
		use({ "seandewar/nvimesweeper", cmd = { "Nvimesweeper" } })
		use({ "tpope/vim-commentary", keys = { "gc" }, cmd = { "Commentary" } })

		use({
			"rcarriga/nvim-notify",
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
		})

		use({
			"nicwest/vim-camelsnek",
			config = config.camelsnek,
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
			config = function()
				vim.g.rose_pine_inactive_background = true
				vim.g.rose_pine_bold_vertical_split_line = true

				require("rose-pine").set("moon")
			end,
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
				"-",
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

		-- use({
		-- 	"renerocksai/telekasten.nvim",
		-- 	config = function()
		-- 		require("config.telekasten").setup()
		-- 	end,
		-- })

		-- use({
		-- 	"antoinemadec/FixCursorHold.nvim",
		-- 	config = function()
		-- 		vim.g.cursorhold_updatetime = 100
		-- 	end,
		-- })

		-- use({
		-- 	"MunifTanjim/nui.nvim",
		-- })
		--
		--		use({
		--			"mattn/emmet-vim",
		--			ft = "html",
		--		})

		--  use({
		--  	"mbbill/undotree",
		--  	cmd = {
		--  		"UndotreeToggle",
		--  	},
		--  })

		--	use({
		--		"justinmk/vim-dirvish",
		--		requires = {
		--			"kristijanhusak/vim-dirvish-git",
		--			"roginfarrer/vim-dirvish-dovish",
		--		},
		--		config = config.dirvish,
		--	})
		--
		--	use({
		--		"tweekmonster/startuptime.vim",
		--		cmd = "StartupTime",
		--	})

		--	use({
		--		"segeljakt/vim-silicon",
		--		cmd = { "Silicon" },
		--	})

		--	use({
		--		"jbyuki/venn.nvim",
		--		keys = { "<Leader>v" },
		--		config = function()
		--			-- enable or disable keymappings for venn
		--			function _G.toggle_venn()
		--				local venn_enabled = vim.inspect(vim.b.venn_enabled)
		--				if venn_enabled == "nil" then
		--					print("venn mode activated!")
		--					vim.cmd("LspStop")
		--					vim.b.venn_enabled = true
		--					vim.cmd([[setlocal ve=all]])
		--					-- draw a line on HJKL keystokes
		--					vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<cr>", { noremap = true })
		--					vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<cr>", { noremap = true })
		--					vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<cr>", { noremap = true })
		--					vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<cr>", { noremap = true })
		--					-- draw a box by pressing "f" with visual selection
		--					vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<cr>", { noremap = true })
		--				else
		--					print("venn mode disengaged!")
		--					vim.cmd("LspStart")
		--					vim.cmd([[setlocal ve=]])
		--					vim.cmd([[mapclear <buffer>]])
		--					vim.b.venn_enabled = nil
		--				end
		--			end
		--			-- toggle keymappings for venn using <leader>v
		--			vim.api.nvim_set_keymap("n", "<leader>v", ":lua toggle_venn()<cr>", { silent = true, noremap = true })
		--		end,
		--	})

		--   use({
		--   	"~/dev/wiki.vim",
		--   	config = function()
		--   		vim.g.wiki_root = "~/irulan/wiki"
		--   		vim.g.wiki_filetypes = { "md" }
		--   		vim.g.wiki_link_extension = ".md"
		--   		vim.g.wiki_link_target_type = "md"
		--   	end,
		--   })

		--		use({
		--			"gruvbox-community/gruvbox",
		--			config = function()
		--				-- vim.cmd("colorscheme gruvbox")
		--			end,
		--		})
	end,
	config = {
		compile_path = vim.fn.stdpath("config") .. "/plugin/packer_compiled.lua",
		max_jobs = 10,
		log = { level = "debug" },
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
		profile = {
			enable = true,
			threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
	},
})
