local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

local get_cstring = require("config.luasnip.get_comment_string")

-- personal_info = {}
local personal_info = {
	username = "zdcthomas",
	email = "zach.thomas@hey.com",
	github = "https://github.com/zdcthomas",
	real_name = "Zach Thomas",
}

local marks = {
	-- signature = function()
	-- 	return t("<" .. personal_info .. ">")
	-- end,
	date_signature = function()
		return t("<" .. os.date("%d-%m-%y") .. ", " .. personal_info.username .. ">")
	end,
	-- date = function()
	-- 	return t("<" .. os.date("%d-%m-%y") .. ">")
	-- end,
	-- empty = function()
	-- 	return fmt("<{}>", { i(1, personal_info })
	-- end,
	-- blank = function()
	-- 	return t("")
	-- end,
}

local todo_snippet_nodes = function(aliases, opts)
	local aliases_nodes = vim.tbl_map(function(alias)
		return t(alias) -- generate choices for [name-of-comment]
	end, aliases)
	aliases_nodes[#aliases_nodes + 1] = i(nil, "Custom")

	local sigmark_nodes = {} -- choices for [comment-mark]
	for _, mark in pairs(marks) do
		table.insert(sigmark_nodes, mark())
	end
	-- format them into the actual snippet
	local comment_node = fmta("<> <>: <> <> <><>", {
		f(function()
			return get_cstring(opts.ctype)[1] -- get <comment-string[1]>
		end),
		c(1, aliases_nodes), -- [name-of-comment]
		c(2, sigmark_nodes), -- [comment-mark]
		i(3), -- {comment-text}
		f(function()
			return get_cstring(opts.ctype)[2] -- get <comment-string[2]>
		end),
		i(0),
	})
	return comment_node
end

--- Generate a TODO comment snippet with an automatic description and docstring
---@param context table merged with the generated context table `trig` must be specified
---@param aliases string[]|string of aliases for the todo comment (ex.: {FIX, ISSUE, FIXIT, BUG})
---@param opts table merged with the snippet opts table
local todo_snippet = function(context, aliases, opts)
	opts = opts or {}
	aliases = type(aliases) == "string" and { aliases } or aliases -- if we do not have aliases, be smart about the function parameters
	context = context or {}
	if not context.trig then
		return error("context doesn't include a `trig` key which is mandatory", 2) -- all we need from the context is the trigger
	end
	opts.ctype = opts.ctype or 1 -- comment type can be passed in the `opts` table, but if it is not, we have to ensure, it is defined
	local alias_string = table.concat(aliases, "|") -- `choice_node` documentation
	context.name = context.name or (alias_string .. " comment") -- generate the `name` of the snippet if not defined
	context.dscr = context.dscr or (alias_string .. " comment with a signature-mark") -- generate the `dscr` if not defined
	context.docstring = context.docstring or (" {1:" .. alias_string .. "}: {3} <{2:mark}>{0} ") -- generate the `docstring` if not defined
	local comment_node = todo_snippet_nodes(aliases, opts) -- nodes from the previously defined function for their generation
	return s(context, comment_node, opts) -- the final todo-snippet constructed from our parameters
end

all_todo_types = {}

for key, _ in pairs(require("todo-comments.config").keywords) do
	table.insert(all_todo_types, key)
end

local todo_snippet_specs = {
	{ { trig = "todo" }, { "TODO", "HACK", "FIX", "BUG", "ISSUE", "WARN", "INFO", "NOTE", "IDEA" } },
	{ { trig = "todoa" }, all_todo_types },
	{ { trig = "fix" }, { "FIX", "BUG", "ISSUE", "FIXIT" } },
	{ { trig = "hack" }, "HACK" },
	{ { trig = "idea" }, "IDEA" },
	{ { trig = "warn" }, { "WARN", "WARNING", "XXX" } },
	{ { trig = "perf" }, { "PERF", "PERFORMANCE", "OPTIM", "OPTIMIZE" } },
	{ { trig = "note" }, { "NOTE", "INFO" } },
	-- NOTE: Block commented todo-comments <kunzaatko>
	{ { trig = "todob" }, "TODO", { ctype = 2 } },
	{ { trig = "fixb" }, { "FIX", "BUG", "ISSUE", "FIXIT" }, { ctype = 2 } },
	{ { trig = "hackb" }, "HACK", { ctype = 2 } },
	{ { trig = "warnb" }, { "WARN", "WARNING", "XXX" }, { ctype = 2 } },
	{ { trig = "perfb" }, { "PERF", "PERFORMANCE", "OPTIM", "OPTIMIZE" }, { ctype = 2 } },
	{ { trig = "noteb" }, { "NOTE", "INFO" }, { ctype = 2 } },
}

local todo_comment_snippets = {}
for _, v in ipairs(todo_snippet_specs) do
	-- NOTE: 3rd argument accepts nil
	table.insert(todo_comment_snippets, todo_snippet(v[1], v[2], v[3]))
end

ls.add_snippets("all", todo_comment_snippets, { type = "snippets", key = "todo_comments" })
