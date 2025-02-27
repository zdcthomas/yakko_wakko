-- If you start to lazy load cmp, this will break cause you're dumbcmp.lu
-- sincerely, Zach from 17-10-2021
--
-- Okay old(younger) Zach, how about this prequire?? huh?
-- Zach from 26-10-2021
--
-- You are like baby, watch this
-- Zach from 12-20-2022
--
-- Ok, I guess blink is a thing now, so I guess we're trying it out over in ./blink.lua
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

					vim.keymap.set(
						"n",
						"<leader>cl",
						crates.toggle,
						vim.tbl_extend("keep", opts, { desc = "[c]rate togg[l]e" })
					)
					vim.keymap.set(
						"n",
						"<leader>cr",
						crates.reload,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [r]eload" })
					)

					vim.keymap.set(
						"n",
						"<leader>cv",
						crates.show_versions_popup,
						vim.tbl_extend("keep", opts, { desc = "[c]rate show [v]ersions" })
					)
					vim.keymap.set(
						"n",
						"<leader>cf",
						crates.show_features_popup,
						vim.tbl_extend("keep", opts, { desc = "[c]rate show [f]eatures" })
					)
					vim.keymap.set(
						"n",
						"<leader>cd",
						crates.show_dependencies_popup,
						vim.tbl_extend("keep", opts, { desc = "[c]rate show [d]ependencies" })
					)

					vim.keymap.set(
						"n",
						"<leader>cu",
						crates.update_crate,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [u]pdate" })
					)
					vim.keymap.set(
						"v",
						"<leader>cu",
						crates.update_crates,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [u]pdate" })
					)
					vim.keymap.set(
						"n",
						"<leader>ca",
						crates.update_all_crates,
						vim.tbl_extend("keep", opts, { desc = "[c]rate update [a]ll" })
					)
					vim.keymap.set(
						"n",
						"<leader>cU",
						crates.upgrade_crate,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [U]pgrade" })
					)
					vim.keymap.set(
						"v",
						"<leader>cU",
						crates.upgrade_crates,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [U]pgrade" })
					)
					vim.keymap.set(
						"n",
						"<leader>cA",
						crates.upgrade_all_crates,
						vim.tbl_extend("keep", opts, { desc = "[c]rate upgrade [a]ll" })
					)

					vim.keymap.set(
						"n",
						"<leader>ce",
						crates.expand_plain_crate_to_inline_table,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [e]xpand" })
					)
					vim.keymap.set(
						"n",
						"<leader>ct",
						crates.extract_crate_into_table,
						vim.tbl_extend("keep", opts, { desc = "extract [c]rate into [t]able" })
					)

					vim.keymap.set(
						"n",
						"<leader>ch",
						crates.open_homepage,
						vim.tbl_extend("keep", opts, { desc = "show [c]rate [Homepage]" })
					)
					vim.keymap.set(
						"n",
						"<leader>cR",
						crates.open_repository,
						vim.tbl_extend("keep", opts, { desc = "open [c]rate [R]epository" })
					)
					vim.keymap.set(
						"n",
						"<leader>cD",
						crates.open_documentation,
						vim.tbl_extend("keep", opts, { desc = "open [c]rate [D]ocumentation" })
					)
					vim.keymap.set(
						"n",
						"<leader>cC",
						crates.open_crates_io,
						vim.tbl_extend("keep", opts, { desc = "show [c]rate on [C]rates.io" })
					)

					vim.keymap.set("n", "gh", crates.show_popup, opts)
				end,
			})
		end,
		opts = {
			completion = {
				crates = {
					enabled = true,
				},
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
			popup = {
				border = "rounded",
			},
			-- src = {
			-- 	cmp = {
			-- 		enabled = true,
			-- 	},
			-- },
		},
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
