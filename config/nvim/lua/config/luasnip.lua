local conf = {}

local luasnip = require("luasnip")
-- some shorthands...
local snippet = luasnip.snippet
local snippet_node = luasnip.snippet_node
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node
local choice_node = luasnip.choice_node
local dynamic_node = luasnip.dynamic_node
local lambda = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local partial = require("luasnip.extras").partial
local match = require("luasnip.extras").match
local nonempty = require("luasnip.extras").nonempty
local dynamic_lambdal = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local s = snippet
local t = text_node
local i = insert_node
local m = match
local n = nonempty
local c = choice_node
local d = dynamic_node
local sn = snippet_node

local function copy(args)
	return args[1]
end

local function rec_ls()
	local snip = sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)

	return s("ls", {
		t({ "\\begin{itemize}", "\t\\item " }),
		i(1),
		d(2, snip, {}),
		t({ "", "\\end{itemize}" }),
	})
end

local function fn_with_copy_func()
	return snippet("fn", {
		-- Simple static text.
		text_node("//Parameters: "),
		-- function, first parameter is the function, second the Placeholders
		-- whose text it gets as input.
		function_node(copy, 2),
		text_node({ "", "function " }),
		-- Placeholder/Insert.
		insert_node(1),
		text_node("("),
		-- Placeholder with initial text.
		insert_node(2, "int foo"),
		-- Linebreak
		text_node({ ") {", "\t" }),
		-- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
		insert_node(0),
		text_node({ "", "}" }),
	})
end

local function today()
	return snippet({
		trig = "today",
	}, {
		text_node(os.date("%d-%m-%Y")),
	})
end

local elixir = {}
local lua = {}

function elixir.typedstruct()
	return snippet({ trig = "typedstruct" }, {
		text_node("typedstruct "),
		insert_node(1),
		text_node("do", "field"),
		insert_node(2),
		text_node("end"),
	})
end

function lua.use()
	return snippet({
		trig = "use2",
	}, {
		text_node({ "use {", "\t" }),
		insert_node(1),
		text_node({ " ", "}" }),
	})
end

function conf.setup()
	luasnip.config.set_config({
		history = true,
		-- Update more often, :h events for more info.
		updateevents = "TextChanged,TextChangedI",
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { "●", "GruvboxOrange" } },
				},
			},
		},
		ext_base_prio = 300,
		-- minimal increase in priority.
		ext_prio_increase = 1,
		enable_autosnippets = true,
	})
	luasnip.snippets = {
		all = {
			today(),
			rec_ls(),
			s("mat2", {
				i(1, { "sample_text" }),
				t(": "),
				m(1, "[abc][abc][abc]"),
			}),
			s("nempty", {
				i(1, "sample_text"),
				n(1, "i(1) is not empty!"),
			}),
			s(
				"fmt1",
				fmt("To {title} {} {}.", {
					i(2, "Name"),
					i(3, "Surname"),
					title = c(1, { t("Mr."), t("Ms.") }),
				})
			),
		},
		lua = {
			fn_with_copy_func(),
			lua.use(),
		},
		elixir = {
			elixir.typedstruct(),
		},
	}

	vim.api.nvim_set_keymap(
		"i",
		"<C-J>",
		'luasnip#choice_active() ? "<Plug>luasnip-next-choice" : "<C-J>"',
		{ expr = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"i",
		"<C-K>",
		'luasnip#choice_active() ? "<Plug>luasnip-prev-choice" : "<C-K>"',
		{ expr = true, silent = true }
	)
	require("config.luasnip.choice_node_popup")
	require("luasnip/loaders/from_vscode").load({ paths = { "~/yakko_wakko/config/nvim/snippets/" } })
end
return conf
