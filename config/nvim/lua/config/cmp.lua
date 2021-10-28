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
local luasnip = prequire("luasnip")
local lspkind = prequire("lspkind")

local function check_back_space()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function tab_handler(fallback)
	if cmp.visible() then
		cmp.mapping(cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" })
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	elseif check_back_space() then
		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
	else
		fallback()
	end
end

local function shift_tab_handler(fallback)
	if cmp.visible() then
		cmp.mapping(cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" })
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	elseif check_back_space() then
		vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n")
	else
		fallback()
	end
end

local function mappings()
	return {
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
		["<C-l>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = false,
		}),
		["<Tab>"] = tab_handler,
		["<S-Tab>"] = shift_tab_handler,
	}
end

local function snippet_func(args)
	luasnip.lsp_expand(args.body)
end

local function sources()
	return {
		{ name = "nvim_lsp", opts = {
			all_panes = true,
		} },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "calc" },
		{ name = "tmux" },
	}
end

function conf.setup()
	cmp.setup({
		snippet = {
			expand = snippet_func,
		},
		preset = "codicons",
		documentation = {
			border = {
				{ "🭽" },
				{ "▔" },
				{ "🭾" },
				{ "▕" },
				{ "🭿" },
				{ "▁" },
				{ "🭼" },
				{ "▏" },
			},
		},
		formatting = {
			format = lspkind.cmp_format({
				maxwidth = 50,
				symbol_map = {
					Unit = "u",
					Enum = "X|Y",
					Snippet = "~",
				},
			}),
		},
		preselect = cmp.PreselectMode.None,
		mapping = mappings(),
		sources = sources(),
		experimental = {
			ghost_text = true,
		},
	})
end

return conf
