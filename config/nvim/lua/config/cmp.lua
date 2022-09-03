local conf = {}
-- If you start to lazy load cmp, this will break cause you're dumb
-- sincerely, Zach from 17-10-2021
--
-- Okay old(younger) Zach, how about this prequire?? huh?
-- Zach from 26-10-2021

local function prequire(...)
	local status, lib = pcall(require, ...)
	if status then
		return lib
	end
	return nil
end

local cmp = prequire("cmp")
if not cmp then
	return
end

local lspkind = prequire("lspkind")
if not lspkind then
	return
end

local luasnip = prequire("luasnip")
if not luasnip then
	return
end

local replace_termcodes = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(replace_termcodes(key), mode, true)
end

local function has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local tab_mapping = {
	c = function(fallback)
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
		elseif has_words_before() then
			vim.fn.feedkeys(replace_termcodes("<Tab>"), "n")
		else
			fallback()
		end
	end,
}

local shift_tab_mapping = {
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
		elseif has_words_before() then
			vim.fn.feedkeys(replace_termcodes("<S-Tab>"), "n")
		else
			fallback()
		end
	end,
}

local function mappings()
	return {
		["<C-n>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump(1)
			else
				fallback()
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
			i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
		}),
		["<Tab>"] = cmp.mapping(tab_mapping),
		["<S-Tab>"] = cmp.mapping(shift_tab_mapping),
	}
end

local function snippet_func(args)
	luasnip.lsp_expand(args.body)
end

local function setup_cmp_highlighting()
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
end

function conf.setup()
	require("config.neorg_cmp")
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
			format = lspkind.cmp_format({
				maxwidth = 50,
				mode = "symbol_text",
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
			{ name = "luasnip", priority = 10 },
			{ name = "buffer", priority = 7, keyword_length = 3 },
			{ name = "nvim_lsp", priority = 9 },
			{ name = "path", priority = 5 },
			{ name = "neorg", priority = 6 },
			{ name = "orgmode", priority = 6 },
		}, {
			{ name = "calc" },
		}),
		experimental = {
			-- This is super super buggy for whatever reason
			ghost_text = false,
		},
	})

	cmp.setup.cmdline("/", {
		sources = {
			{ name = "buffer" },
		},
	})
	setup_cmp_highlighting()
end

return conf
