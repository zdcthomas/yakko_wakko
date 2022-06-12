local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local m = require("luasnip.extras").m
local conds = require("luasnip.extras.expand_conditions")
-- local l = require("luasnip.extras").l

ls.config.set_config({
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged,InsertEnter",
	region_check_events = "CursorMoved",
	enable_autosnippets = false,
	store_selection_keys = "<Tab>",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { " ", "Boolean" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "●", "Special" } },
			},
		},
	},
})

-- later improvement, if file is larger than a limit, batch lines
local function file_contains(match)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local found = false
	for _, line in ipairs(lines) do
		if line:match(match) then
			found = true
			break
		end
	end
	return found
end

local function comment()
	return string.format(vim.opt.commentstring:get(), " ")
end

ls.add_snippets("all", {

	s("box", {
		f(comment),
		t("-----"),
		l(l._1:gsub(".", "-"), 1),
		t({ "-----", "" }),

		f(comment),
		t("|    "),
		i(1, "header title"),
		t({ "    |", "" }),

		f(comment),
		t("-----"),
		l(l._1:gsub(".", "-"), 1),
		t({ "-----", "" }),
	}),
	s({
		trig = "(%w+)%.Pr",
		regTrig = true,
		wordTrig = false,
		hiden = true,
	}, {
		f(function(_, parent)
			Pr(parent.snippet.captures)
			return "Pr(" .. parent.snippet.captures[1] .. ")"
		end),
		-- l("(" .. l.CAPTURE1 .. ")", {}),
	}),
}, { key = "testsnippetshehe" })

ls.add_snippets("elixir", {
	s(
		"test",
		fmt(
			[[
	test "{}"{} do
	  {}
  end
	]],
			{
				i(1, "test_name"),
				d(2, function()
					if file_contains("setup") then
						return sn(
							nil,
							c(1, {
								fmt(", %{<>: <>}", { i(1), rep(1) }, { delimiters = "<>" }),
								t(""),
							})
						)
					else
						return sn(nil, t(""))
					end
				end),
				i(3),
			}
		)
	),
	s(
		"bind",
		c(1, {
			t([[require IEx;IEx.pry()]]),
			fmt(
				[[
				|> (fn {scope} ->
            require IEx
            IEx.pry()
            {rep}
          end).()
        ]],
				{ scope = i(1, "scope"), rep = rep(1) }
			),
		})
	),
}, { key = "elixir" })
require("luasnip").get_snippets("lua", { type = "snippets" })

ls.add_snippets("lua", {
	-- s({
	-- 	trig = "(%w+)%.pr",
	-- 	regTrig = true,
	-- 	wordTrig = false,
	-- 	dscr = "parenthetical",
	-- 	docstring = "par",
	-- 	name = "test paren",
	-- }, {
	-- 	f(function(_, parent)
	-- 		return "Pr(" .. parent.snippet.captures[1] .. ")"
	-- 	end),
	-- 	-- l("(" .. l.CAPTURE1 .. ")", {}),
	-- }),
	-- s({ trig = "(%w+)%.parens", regTrig = true, wordTrig = true }, {
	-- 	f(function(_, parent)
	-- 		return "(" .. parent.snippet.captures[1] .. ")"
	-- 	end),
	-- }),
	s(
		{ trig = "b(%d)", regTrig = true },
		f(function(args, snip)
			Pr(snip.captures[1])
			return "Captured Text: " .. snip.captures[1] .. "."
		end, {})
	),
	s(
		"use",
		fmt(
			[[
			use({"<>",
        <>
      })
		  ]],
			{
				d(1, function()
					-- get from the system clipboard
					local clip = vim.fn.getreg("*", 1, true)[1]
					-- get the packer/plug usable location from either a full url or just a part
					local usable = string.match(clip, "[%a%d%.]+/[%a%d%.]+$")
					if usable then
						return sn(nil, { i(nil, usable) })
					else
						return sn(nil, { i(1) })
					end
				end),
				i(2),
			},
			{
				delimiters = "<>",
			}
		)
	),
	s(
		"local require",
		fmt([[local {} = require("{}")]], {
			f(function(import_name, snip)
				local parts = vim.split(import_name[1][1], ".", true)
				return parts[#parts] or ""
			end, { 1 }),
			i(1),
		})
	),
}, { key = "lua" })

ls.add_snippets("rust", {
	s(
		"mod test",
		fmt(
			[[
  #[cfg(test)]
  mod tests {
    <>
  }
  ]],
			{
				c(1, {
					sn(nil, { t("use super::"), i(1, "*"), t(";") }),
					t(""),
				}),
			},
			{ delimiters = "<>" }
		)
	),

	-- add choice nodes for return type of test
	-- maybe use tj's anyhow check also
	-- "test": {
	--   "prefix": "test",
	--   "body": [
	--     "#[test]",
	--     "fn ${1:name}() {",
	--     "    ${2:unimplemented!();}",
	--     "}"
	--   ],
	--   "description": "#[test]"
	-- }
}, { key = "rust" })

ls.add_snippets("norg", {
	s("code", {
		fmt(
			[[
    @code {}
      {}
    @end
    ]],
			{ i(1, "lang"), i(2) }
		),
	}),
}, { key = "norg" })

-- ls.add_snippets("norg", {
-- 	s("norg code", { -- neorg tag
-- 		t({ "@code", "" }),
-- 		-- insert code, text, " ", insert lang
-- 		i(1, "code goes here.."),
-- 		t({ "", "@end" }),
-- 	}),
-- 	s("neorg link curly", {
-- 		t("{"),
-- 		i(1, "name"),
-- 		t("}["),
-- 		i(2, "link"),
-- 		t("]"),
-- 	}),
-- 	s("neorg link paren", {
-- 		t("("),
-- 		i(1, "name"),
-- 		t(")["),
-- 		i(2, "link"),
-- 		t("]"),
-- 	}),
-- 	s("neorg link square", {
-- 		t("["),
-- 		i(1, "name"),
-- 		t("]["),
-- 		i(2, "link"),
-- 		t("]"),
-- 	}),
-- })

require("luasnip.loaders.from_vscode").lazy_load({
	paths = { "~/yakko_wakko/config/nvim/snippets" },
})
require("config.luasnip.choice_popup")

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/yakko_wakko/config/nvim/lua/config/luasnip/init.lua<CR>")
