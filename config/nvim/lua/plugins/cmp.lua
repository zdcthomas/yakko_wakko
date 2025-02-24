-- If you start to lazy load cmp, this will break cause you're dumbcmp.lu
-- sincerely, Zach from 17-10-2021
--
-- Okay old(younger) Zach, how about this prequire?? huh?
-- Zach from 26-10-2021
--
-- You are like baby, watch this
-- Zach from 12-20-2022
--
-- Ok, I guess blink is a thing now, so I guess we're trying it out
-- Zach from 24-2-2025

local function snippet_func(args)
	require("luasnip").lsp_expand(args.body)
end

local replace_termcodes = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(replace_termcodes(key), mode, true)
end

return {
	{
		"saecki/crates.nvim",
		version = false,
		event = { "BufRead Cargo.toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		init = function()
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function(ev)
					---@diagnostic disable-next-line: missing-fields
					local crates = require("crates")
					local opts = { silent = true, buffer = ev.buf }

					vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
					vim.keymap.set("n", "<leader>cr", crates.reload, opts)

					vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
					vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
					vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)

					vim.keymap.set("n", "<leader>cu", crates.update_crate, opts)
					vim.keymap.set("v", "<leader>cu", crates.update_crates, opts)
					vim.keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
					vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, opts)
					vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, opts)
					vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, opts)

					vim.keymap.set("n", "<leader>ce", crates.expand_plain_crate_to_inline_table, opts)
					vim.keymap.set("n", "<leader>cE", crates.extract_crate_into_table, opts)

					vim.keymap.set("n", "<leader>cH", crates.open_homepage, opts)
					vim.keymap.set("n", "<leader>cR", crates.open_repository, opts)
					vim.keymap.set("n", "<leader>cD", crates.open_documentation, opts)
					vim.keymap.set("n", "<leader>cC", crates.open_crates_io, opts)

					vim.keymap.set("n", "gh", crates.show_popup, opts)
				end,
			})
		end,
		opts = {
			popup = {
				border = "rounded",
			},
			src = {
				cmp = {
					enabled = true,
				},
			},
		},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		enabled = true,
		dependencies = {
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			{
				"xzbdmw/colorful-menu.nvim",
				opts = {},
			},
		},

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- selection = {
			--   preselect = false,
			--   },
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = "default",

				-- -- show with a list of providers
				["<CR>"] = { "select_and_accept", "fallback" },
				["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-n>"] = { "select_next", "snippet_forward", "fallback" },

				-- optionally, separate cmdline and terminal keymaps
			},

			cmdline = {

				keymap = {
					preset = "super-tab",

					-- sets <CR> to accept the item and run the command immediately
					-- use `select_accept_and_enter` to accept the item or the first item if none are selected
					-- ["<CR>"] = {},
					--
					-- [""] = { "select_prev", "snippet_backward", "fallback" },
					-- ["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
				},
			},
			completion = {
				menu = {
					draw = {
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},

					border = "rounded",
				},
				documentation = {

					auto_show = true,
					auto_show_delay_ms = 500,
					window = { border = "rounded" },
				},
			},
			snippets = { preset = "luasnip" },
			signature = {
				enabled = true,
				window = {
					show_documentation = false,
					border = "rounded",
				},
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"hrsh7th/nvim-cmp",
		enabled = false,
		-- wants = { "LuaSnip" },
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"davidmh/cmp-nerdfonts",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"onsails/lspkind-nvim",
			"petertriho/cmp-git",
			"saadparwaiz1/cmp_luasnip",
			"windwp/nvim-autopairs",
		},
		config = function()
			-- See lspconfig comment on why this is in a function wrapper
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			---@diagnostic disable-next-line: missing-fields
			cmp.setup({

				view = {
					entries = {
						follow_cursor = true,
					},
				},
				snippet = {
					expand = snippet_func,
				},
				preset = "codicons",
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				---@diagnostic disable-next-line: missing-fields
				formatting = {
					format = require("lspkind").cmp_format({
						maxwidth = 50,
						mode = "symbol",
						menu = {}, -- this is too help with rust menu width issues, see https://github.com/hrsh7th/nvim-cmp/issues/1154
						symbol_map = {
							nvim_lsp = "[LSP]",
							Unit = "u",
							Enum = "X|Y",
							Snippet = "~",
						},
					}),
				},
				---@diagnostic disable-next-line: missing-fields
				matching = { disallow_fuzzy_matching = false },
				preselect = cmp.PreselectMode.None,
				mapping = {
					["<C-n>"] = cmp.mapping(function(fallback)
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump(1)
						else
							cmp.complete()
						end
					end, {
						"i",
						"s",
					}),
					["<C-p>"] = cmp.mapping(function(fallback)
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump(-1)
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
					["<C-j>"] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_selected_entry() then
							cmp.scroll_docs(4)
						elseif luasnip.choice_active() then
							luasnip.change_choice(1)
						else
							fallback()
						end
					end, { "i", "c" }),
					["<C-k>"] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_selected_entry() then
							cmp.scroll_docs(-4)
						elseif luasnip.choice_active() then
							luasnip.change_choice(-1)
						else
							fallback()
						end
					end, { "i", "c" }),
					["<C-c>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
					["<CR>"] = cmp.mapping({
						i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
					}),
					["<Tab>"] = cmp.mapping({
						c = function(_)
							if cmp.visible() then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
							else
								if vim.fn.getcmdtype() == "/" then
									cmp.complete()
								else
									feedkey("<Tab>", "tn")
								end
							end
						end,
						i = function(fallback)
							if cmp.visible() then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							-- elseif has_words_before() then
							-- 	vim.fn.feedkeys(replace_termcodes("<Tab>"), "n")
							else
								fallback()
							end
						end,
					}),
					["<S-Tab>"] = cmp.mapping({
						c = function(fallback)
							if cmp.visible() then
								cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
							else
								if vim.fn.getcmdtype() == "/" then
									cmp.complete()
								else
									fallback()
								end
							end
						end,
						i = function(fallback)
							if cmp.visible() then
								cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
							-- elseif has_words_before() then
							-- 	vim.fn.feedkeys(replace_termcodes("<S-Tab>"), "n")
							else
								fallback()
							end
						end,
					}),
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 9 },
					{ name = "luasnip", priority = 8 },
					{ name = "mkdnflow" },
					{ name = "buffer", priority = 7, keyword_length = 3 },
					{ name = "path", priority = 5 },
					{ name = "nerdfonts" },
					{ name = "crates" },
				}, {
					{ name = "calc" },
				}),
				experimental = {
					-- This is super super buggy for whatever reason
					ghost_text = {
						enabled = true,
						-- hl_group = "CmpGhostText",
					},
				},
			})

			---@diagnostic disable-next-line: missing-fields
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
				}, {
					{ name = "buffer" },
				}),
			})

			---@diagnostic disable-next-line: missing-fields
			cmp.setup.cmdline({ "/", "?" }, {
				sources = {
					{ name = "buffer" },
				},
			})

			---@diagnostic disable-next-line: missing-fields
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			vim.cmd([[
      " gray
      highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
      " blue
      highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
      highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
      " light blue
      highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
      highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
      highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
      " pink
      highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
      highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
      " front
      highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
      highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
      highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
    ]])
		end,
	},
}
