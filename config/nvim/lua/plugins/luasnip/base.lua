---@diagnostic disable: unused-local
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
local util = require("luasnip.util.util")
local ai = require("luasnip.nodes.absolute_indexer")
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local postfix = require("luasnip.extras.postfix").postfix
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local match_link = [[[%w%.%_%-%/%p%"%']+$]]
local non_space = "%S+$"

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end, { silent = true })

ls.config.set_config({
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "TextChanged,InsertEnter",
	region_check_events = "CursorHold,InsertLeave",
	enable_autosnippets = false,
	store_selection_keys = "<Tab>",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "", "Boolean" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "●", "Special" } },
			},
		},
	},
})

local function get_username_and_reponame_from_url(clip)
	-- get from the system clipboard
	-- local clip = vim.fn.getreg("*", 1, true)[1]
	-- get the packer/plug usable location from either a full url or just a part
	local usable = nil
	if string.match(clip, "%.com") then
		if string.match(clip, "github") then
			usable = string.match(clip, "%.com%/([%w%.%-%_]+/[%w%.%-%_]+)")
		else
			usable = string.match(clip, "(.+%.com%/[%w%.%-%_]+/[%w%.%-%_]+)")
		end
	end
	if usable then
		return sn(nil, { i(nil, usable) })
	else
		return sn(nil, { i(1) })
	end
end

local function dyn_i(index, func)
	return d(index, function(...)
		return sn(nil, i(1, func(...)))
	end)
end

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
}, { key = "all" })

ls.add_snippets("sh", {

	s("header", {
		t([[echo "-----]]),
		l(l._1:gsub(".", "-"), 1),
		t({ [[-----"]], "" }),

		t([[echo "|    ]]),
		i(1, "header title"),
		t({ [[    |"]], "" }),

		t([[echo "-----]]),
		l(l._1:gsub(".", "-"), 1),
		t({ [[-----"]], "" }),
	}),
}, { key = "sh" })
ls.add_snippets("tex", {

	s("header", {
		t([[echo "-----]]),
		l(l._1:gsub(".", "-"), 1),
		t({ [[-----"]], "" }),

		t([[echo "|    ]]),
		i(1, "header title"),
		t({ [[    |"]], "" }),

		t([[echo "-----]]),
		l(l._1:gsub(".", "-"), 1),
		t({ [[-----"]], "" }),
	}),
}, { key = "sh" })

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
	postfix(
		".pr",
		fmt([[vim.print("{}", {})]], {
			dyn_i(2, function(_, parent)
				return parent.snippet.env.POSTFIX_MATCH
			end),
			dyn_i(1, function(_, parent)
				return parent.snippet.env.POSTFIX_MATCH
			end),
		})
	),
	s(
		"pr",
		fmt([[vim.print("{}", {})]], {
			rep(1),
			i(1),
		})
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
					return get_username_and_reponame_from_url(clip)
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
	s("derivedebug", t("#[derive(Debug)]")),
	s(":turbofish", { t({ "::<" }), i(0), t({ ">" }) }),
	s(
		"test",
		fmt(
			[[
    #[test]
    fn <>() {
      <>
    }
  ]],
			{
				i(1, "test"),
				i(2, "unimplemented!();"),
			},
			{ delimiters = "<>" }
		)
	),
}, { key = "rust" })

ls.add_snippets("norg", {
	s(
		"code",
		fmt(
			[[ 
	@code {}
	{}
	@end
	]],
			{ i(1, "lang"), i(2) }
		)
	),
}, { key = "norg" })

local ts_snipets = {

	postfix(
		{ trig = ".l", match_pattern = non_space },
		fmt([[console.log("{}", {})]], {
			dyn_i(2, function(_, parent)
				return parent.snippet.env.POSTFIX_MATCH
			end),
			dyn_i(1, function(_, parent)
				return parent.snippet.env.POSTFIX_MATCH
			end),
		})
	),
}

ls.add_snippets("typescript", ts_snipets, { key = "typescript" })
ls.add_snippets("typescriptreact", ts_snipets, { key = "typescriptreact" })

ls.add_snippets("nix", {
	s(
		"module",
		fmt(
			[[
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.hm.<module>;
in {
  options = {
    custom.hm.<module> = {
      enable = lib.mkEnableOption "Enable custom <module>";
    };
  };
  config = lib.mkIf cfg.enable {};
}
  ]],
			{
				module = i(1, "module"),
			},
			{ delimiters = "<>", repeat_duplicates = true }
		)
	),
})

ls.add_snippets("markdown", {
	s(
		"link",
		fmt("[{}]({})", {
			i(1),
			i(2),
		})
	),
	s(
		{ trig = "table(%d+)x(%d+)", regTrig = true },
		d(1, function(args, snip)
			local nodes = {}
			local i_counter = 0
			local hlines = ""
			for _ = 1, snip.captures[2] do
				i_counter = i_counter + 1
				table.insert(nodes, t("| "))
				table.insert(nodes, i(i_counter, "Column" .. i_counter))
				table.insert(nodes, t(" "))
				hlines = hlines .. "|---"
			end
			table.insert(nodes, t({ "|", "" }))
			hlines = hlines .. "|"
			table.insert(nodes, t({ hlines, "" }))
			for _ = 1, snip.captures[1] do
				for _ = 1, snip.captures[2] do
					i_counter = i_counter + 1
					table.insert(nodes, t("| "))
					table.insert(nodes, i(i_counter))
					print(i_counter)
					table.insert(nodes, t(" "))
				end
				table.insert(nodes, t({ "|", "" }))
			end
			return sn(nil, nodes)
		end)
	),
	s(
		"front_matter",
		fmt(
			[[
      ---
      title: {}
      draft: {}
      tags:
        - {}
      ---
    ]],
			{
				i(1),
				i(2),
				i(3),
			}
		)
	),
	postfix(
		{ trig = ".link", match_pattern = non_space },
		d(1, function(_, snippet)
			local link_or_desc = snippet.env.POSTFIX_MATCH
			local link
			local desc
			if link_or_desc:match("http") or link_or_desc:match("/") then
				link = i(1, link_or_desc)
				desc = i(2, "desc")
			else
				link = i(2, "link")
				desc = i(1, link_or_desc)
			end
			return sn(
				nil,
				fmt("[{}]({})", {
					desc,
					link,
				})
			)
		end)
	),
}, { key = "markdown" })

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
	paths = { "~/yakko_wakko/config/nvim/snippets/" },
})
require("plugins.luasnip.todo_comments")
require("plugins.luasnip.choice_popup")

vim.keymap.set("i", "<C-n>", function()
	require("luasnip").expand_auto()
end, {})
