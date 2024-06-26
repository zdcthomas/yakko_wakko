-- local Hydra = require("hydra")

local hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} Virtual Edit
  _i_ %{list} Invisible Characters
  _s_ %{spell} Spell
  _w_ %{wrap} Wrap
  _c_ %{cul} Cursor Line
  _n_ %{number} Number
  _r_ %{rnu} Relative Number
  _f_ %{format_on_save} Format On Save?
  ^
       ^^^^                _<Esc>_
]]
local check = function(callback)
	return function()
		if callback() then
			return "[x]"
		else
			return "[ ]"
		end
	end
end

local function option_check(opt_name)
	check(function()
		return vim.o[opt_name]
	end)
end

return {
	name = "Options",
	hint = hint,
	config = {
		color = "amaranth",
		invoke_on_body = true,
		hint = {
			position = "top-right",
			funcs = {
				number = option_check("number"),
				format_on_save = check(function()
					return not not vim.g.format_on_save
				end),
			},
		},
	},
	mode = { "n" },
	heads = {
		{
			"n",
			function()
				if vim.o.number == true then
					vim.o.number = false
				else
					vim.o.number = true
				end
			end,
			{ desc = "number" },
		},
		{
			"r",
			function()
				if vim.o.relativenumber == true then
					vim.o.relativenumber = false
				else
					vim.o.number = true
					vim.o.relativenumber = true
				end
			end,
			{ desc = "relativenumber" },
		},
		{
			"v",
			function()
				if vim.o.virtualedit == "all" then
					vim.o.virtualedit = "block"
				else
					vim.o.virtualedit = "all"
				end
			end,
			{ desc = "virtualedit" },
		},
		{
			"i",
			function()
				if vim.o.list == true then
					vim.o.list = false
				else
					vim.o.list = true
				end
			end,
			{ desc = "show invisible" },
		},
		{
			"s",
			function()
				if vim.o.spell == true then
					vim.o.spell = false
				else
					vim.o.spell = true
				end
			end,
			{ exit = true, desc = "spell" },
		},
		{
			"w",
			function()
				if vim.o.wrap ~= true then
					vim.o.wrap = true
					-- Dealing with word wrap:
					-- If cursor is inside very long line in the file than wraps
					-- around several rows on the screen, then 'j' key moves you to
					-- the next line in the file, but not to the next row on the
					-- screen under your previous position as in other editors. These
					-- bindings fixes this.
					vim.keymap.set("n", "k", function()
						return vim.v.count > 0 and "k" or "gk"
					end, { expr = true, desc = "k or gk" })
					vim.keymap.set("n", "j", function()
						return vim.v.count > 0 and "j" or "gj"
					end, { expr = true, desc = "j or gj" })
				else
					vim.o.wrap = false
					vim.keymap.del("n", "k")
					vim.keymap.del("n", "j")
				end
			end,
			{ desc = "wrap" },
		},
		{
			"c",
			function()
				if vim.o.cursorline == true then
					vim.o.cursorline = false
				else
					vim.o.cursorline = true
				end
			end,
			{ desc = "cursor line" },
		},
		{
			"f",
			function()
				vim.g.format_on_save = not vim.g.format_on_save
			end,
			{ desc = "cursor line" },
		},
		{ "<Esc>", nil, { exit = true } },
	},
}
