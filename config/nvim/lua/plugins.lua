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
		use("wbthomason/packer.nvim")
		use({
			"theblob42/drex.nvim",
			requires = "kyazdani42/nvim-web-devicons", -- optional
			config = function()
				require("drex.config").configure({
					icons = {
						file_default = "",
						dir_open = "",
						dir_closed = "",
						link = "",
						others = "",
					},
					colored_icons = true,
					hide_cursor = false,
					hijack_netrw = false,
					sorting = function(a, b)
						local aname, atype = a[1], a[2]
						local bname, btype = b[1], b[2]

						local aisdir = atype == "directory"
						local bisdir = btype == "directory"

						if aisdir ~= bisdir then
							return aisdir
						end

						return aname < bname
					end,
					disable_default_keybindings = false,
					keybindings = {
						["n"] = {
							["v"] = "V",
							["l"] = '<cmd>lua require("drex").expand_element()<CR>',
							["h"] = '<cmd>lua require("drex").collapse_directory()<CR>',
							["<CR>"] = function()
								local drex = require("drex")
								local line = vim.api.nvim_get_current_line()

								if require("drex.utils").is_open_directory(line) then
									drex.collapse_directory()
								else
									drex.expand_element()
								end
							end,
							["<right>"] = '<cmd>lua require("drex").expand_element()<CR>',
							["<left>"] = '<cmd>lua require("drex").collapse_directory()<CR>',
							["<2-LeftMouse>"] = '<LeftMouse><cmd>lua require("drex").expand_element()<CR>',
							["<RightMouse>"] = '<LeftMouse><cmd>lua require("drex").collapse_directory()<CR>',
							["<C-v>"] = '<cmd>lua require("drex").open_file("vs")<CR>',
							["<C-x>"] = '<cmd>lua require("drex").open_file("sp")<CR>',
							["<C-t>"] = '<cmd>lua require("drex").open_file("tabnew")<CR>',
							["<C-l>"] = '<cmd>lua require("drex").open_directory()<CR>',
							["<C-h>"] = '<cmd>lua require("drex").open_parent_directory()<CR>',
							["<F5>"] = '<cmd>lua require("drex").reload_directory()<CR>',
							["gj"] = '<cmd>lua require("drex.jump").jump_to_next_sibling()<CR>',
							["gk"] = '<cmd>lua require("drex.jump").jump_to_prev_sibling()<CR>',
							["gh"] = '<cmd>lua require("drex.jump").jump_to_parent()<CR>',
							["s"] = '<cmd>lua require("drex.actions").stats()<CR>',
							["a"] = '<cmd>lua require("drex.actions").create()<CR>',
							["d"] = '<cmd>lua require("drex.actions").delete("line")<CR>',
							["D"] = '<cmd>lua require("drex.actions").delete("clipboard")<CR>',
							["p"] = '<cmd>lua require("drex.actions").copy_and_paste()<CR>',
							["P"] = '<cmd>lua require("drex.actions").cut_and_move()<CR>',
							["r"] = '<cmd>lua require("drex.actions").rename()<CR>',
							["R"] = '<cmd>lua require("drex.actions").multi_rename("clipboard")<CR>',
							["M"] = "<cmd>DrexMark<CR>",
							["u"] = "<cmd>DrexUnmark<CR>",
							["m"] = "<cmd>DrexToggle<CR>",
							["cc"] = '<cmd>lua require("drex.actions").clear_clipboard()<CR>',
							["cs"] = '<cmd>lua require("drex.actions").open_clipboard_window()<CR>',
							["y"] = '<cmd>lua require("drex.actions").copy_element_name()<CR>',
							["Y"] = '<cmd>lua require("drex.actions").copy_element_relative_path()<CR>',
							["<C-y>"] = '<cmd>lua require("drex.actions").copy_element_absolute_path()<CR>',
						},
						["v"] = {
							["d"] = ':lua require("drex.actions").delete("visual")<CR>',
							["r"] = ':lua require("drex.actions").multi_rename("visual")<CR>',
							["M"] = ":DrexMark<CR>",
							["u"] = ":DrexUnmark<CR>",
							["m"] = ":DrexToggle<CR>",
							["y"] = ':lua require("drex.actions").copy_element_name(true)<CR>',
							["Y"] = ':lua require("drex.actions").copy_element_relative_path(true)<CR>',
							["<C-y>"] = ':lua require("drex.actions").copy_element_absolute_path(true)<CR>',
						},
					},
					on_enter = nil,
					on_leave = nil,
				})
			end,
		})
		use({
			"shaunsingh/nord.nvim",
			config = function()
				-- vim.g.nord_contrast = true
				vim.g.nord_borders = true
				-- vim.g.nord_disable_background = false
				vim.g.nord_italic = true
				vim.g.nord_uniform_diff_background = true
				-- require("nord").set()
			end,
		})

		use("antoinemadec/FixCursorHold.nvim")
		use("lewis6991/impatient.nvim")
		use("michaeljsmith/vim-indent-object")
		use({
			"mattn/emmet-vim",
			config = function()
				vim.g.user_emmet_mode = "a"
			end,
		})

		use({
			-- The only downside I've found to this vs. sandwich is that tags don't
			-- have the same nice syntax
			"tpope/vim-surround",
			requires = {
				"tpope/vim-repeat",
				{
					"AndrewRadev/dsf.vim",
					config = function()
						vim.g.dsf_brackets = "("
					end,
				},
			},
			config = require("config.vim_surround").setup,
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
				yop.op_map({ "n", "v" }, "gs", function(lines, opts)
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

		-- -- use({ "kevinhwang91/nvim-bqf", ft = "qf" })
		use({ "seandewar/nvimesweeper", cmd = { "Nvimesweeper" } })
		use({ "tpope/vim-commentary", keys = { "gc" }, cmd = { "Commentary" } })
		-- -- use({
		-- -- 	"b0o/incline.nvim",
		-- -- 	config = function()
		-- -- 		require("incline").setup({
		-- -- 			highlight = {
		-- -- 				groups = {
		-- -- 					InclineNormal = "PmenuSel",
		-- -- 					InclineNormalNC = "PmenuSbar",
		-- -- 				},
		-- -- 			},
		-- -- 			window = {
		-- -- 				winhighlight = {
		-- -- 					inactive = {
		-- -- 						Normal = "",
		-- -- 					},
		-- -- 				},
		-- -- 				margin = {
		-- -- 					vertical = 0,
		-- -- 				},
		-- -- 			},
		-- -- 			hide = {
		-- -- 				focused_win = true,
		-- -- 				only_win = true,
		-- -- 			},
		-- -- 		})
		-- -- 	end,
		-- -- })

		use({
			"stevearc/dressing.nvim",
			config = config.dressing,
		})

		-- -- use({
		-- -- 	"takac/vim-hardtime",
		-- -- 	cmd = {
		-- -- 		"HardTimeOff",
		-- -- 		"HardTimeToggle",
		-- -- 		"HardTimeOn",
		-- -- 	},
		-- -- 	config = config.hardtime,
		-- -- })

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
			branch = "parse_from_ast",
			rocks = { "jsregexp" },
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
				-- { "nvim-telescope/telescope-fzf-writer.nvim" },
				-- { "nvim-telescope/telescope-file-browser.nvim" },
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
			"williamboman/mason.nvim",
			requires = { "williamboman/mason-lspconfig.nvim" },
			config = function()
				require("mason").setup()
			end,
		})

		use({
			"neovim/nvim-lspconfig",
			requires = {
				-- "ckipp01/stylua-nvim",
				"mhanberg/elixir.nvim",
				"hrsh7th/nvim-cmp",
				"kosayoda/nvim-lightbulb",
				"nvim-lua/lsp-status.nvim",
				"nvim-telescope/telescope.nvim",
				{
					"ray-x/lsp_signature.nvim",
					config = function()
						-- require("lsp_signature").setup({})
					end,
				},
				"williamboman/mason.nvim",
			},
			config = function()
				-- Ok I really don't understand this. If I remove this function
				-- wrapper, then any local function defined within config/lspconfig
				-- won't be usable by the setup function. This makes no sense.
				require("config.lspconfig").setup()
			end,
		})

		-- -- use({
		-- -- 	"nvim-lua/plenary.nvim",
		-- -- 	config = function()
		-- -- 		local plen_group = vim.api.nvim_create_augroup("PlenaryGroupBindings", { clear = true })
		-- -- 		vim.api.nvim_create_autocmd("FileType", {
		-- -- 			group = plen_group,
		-- -- 			pattern = { "lua" },
		-- -- 			callback = function()
		-- -- 				vim.keymap.set("n", "<leader><leader>t", "<Plug>PlenaryTestFile", { buffer = true })
		-- -- 			end,
		-- -- 		})
		-- -- 	end,
		-- -- })

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
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				local augroup = vim.api.nvim_create_augroup("LspFormattingNull", {})
				local null = require("null-ls")
				null.setup({
					sources = {
						null.builtins.formatting.stylua,
						null.builtins.diagnostics.eslint,
						null.builtins.code_actions.statix,
						null.builtins.formatting.prettierd.with({
							filetypes = {
								"javascript",
								"javascriptreact",
								"typescript",
								"typescriptreact",
								"vue",
								"css",
								"scss",
								"less",
								"html",
								"graphql",
							},
						}),
					},
					on_attach = function(client, bufnr)
						if client.supports_method("textDocument/formatting") then
							vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
							vim.api.nvim_create_autocmd("BufWritePre", {
								group = augroup,
								buffer = bufnr,
								callback = function()
									-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
									vim.lsp.buf.formatting_sync()
								end,
							})
						end

						Pr("client.name", client.name)
					end,
				})
			end,
		})

		-- -- use({
		-- -- 	"segeljakt/vim-silicon",
		-- -- 	cmd = { "Silicon" },
		-- -- })

		use({
			"mhartington/formatter.nvim",
			-- Utilities for creating configurations
			config = function()
				vim.g.save_format = true
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
						typescript = {
							require("formatter.filetypes.typescript").prettierd,
						},
						typescriptreact = {
							require("formatter.filetypes.typescriptreact").prettierd,
						},

						elixir = {
							require("formatter.filetypes.elixir").mixformat,
						},
						lua = {
							require("formatter.filetypes.lua").stylua,
						},
					},
				})

				local formatter_group = vim.api.nvim_create_augroup("formatter_group", { clear = true })

				vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					group = formatter_group,
					pattern = "*",
					callback = function()
						if vim.g.save_format then
							vim.cmd("FormatWrite")
						end
					end,
					desc = "Map q to close buffer",
				})
			end,
		})

		use({
			"nvim-neorg/neorg",
			config = function()
				require("config.neorg").setup()
			end,
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-neorg/neorg-telescope",
			},
		})

		use({
			"nvim-orgmode/orgmode",
			config = function()
				require("orgmode").setup_ts_grammar()
				require("orgmode").setup({
					org_agenda_files = { "~/irulan/org/*" },
					org_default_notes_file = "~/irulan/org/refile.org",
				})
			end,
		})

		use({
			"anuvyklack/hydra.nvim",
			config = function()
				require("config.hydra").setup()
			end,
		})

		-- -- use("neovim/nvimdev.nvim")

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
