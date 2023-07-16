-- If you start to lazy load cmp, this will break cause you're dumb
-- sincerely, Zach from 17-10-2021
--
-- Okay old(younger) Zach, how about this prequire?? huh?
-- Zach from 26-10-2021
--
-- You are like baby, watch this
-- Zach from 12-20-2022
local function snippet_func(args)
	require("luasnip").lsp_expand(args.body)
end

local replace_termcodes = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(replace_termcodes(key), mode, true)
end

local function mappings()
	local luasnip = require("luasnip")
	local cmp = require("cmp")
	return {
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
	}
end

return {
	"hrsh7th/nvim-cmp",
	-- wants = { "LuaSnip" },
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-calc",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind-nvim",
		"petertriho/cmp-git",
		"L3MON4D3/LuaSnip",
		"windwp/nvim-autopairs",
	},
	config = function()
		-- See lspconfig comment on why this is in a function wrapper
		local cmp = require("cmp")
		cmp.setup({
			snippet = {
				expand = snippet_func,
			},
			preset = "codicons",
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				format = require("lspkind").cmp_format({
					maxwidth = 20,
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
			matching = { disallow_fuzzy_matching = false },
			preselect = cmp.PreselectMode.None,
			mapping = mappings(),
			sources = cmp.config.sources({
				{ name = "nvim_lsp", priority = 9 },
				{ name = "luasnip", priority = 10 },
				{ name = "buffer", priority = 7, keyword_length = 3 },
				{ name = "path", priority = 5 },
			}, {
				{ name = "calc" },
			}),
			experimental = {
				-- This is super super buggy for whatever reason
				ghost_text = false,
			},
		})

		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
			}, {
				{ name = "buffer" },
			}),
		})

		cmp.setup.cmdline({ "/", "?" }, {
			sources = {
				{ name = "buffer" },
			},
		})

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
}
