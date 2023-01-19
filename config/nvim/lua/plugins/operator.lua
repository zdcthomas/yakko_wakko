local sort = function(lines, _)
	local utils = require("yop.utils")
	-- We don't care about anything non alphanumeric here
	local sort_without_leading_space = function(a, b)
		-- true = a then b
		-- false = b then a
		local pattern = [[^%W*]]
		return string.gsub(a, pattern, "") < string.gsub(b, pattern, "")
	end
	if #lines == 1 then
		-- local delimeter = utils.get_input("Delimeter: ")
		local delimeter = ","
		local split = vim.split(lines[1], delimeter, { trimempty = true })
		-- Remember! `table.sort` mutates the table itself
		table.sort(split, sort_without_leading_space)
		return { utils.join(split, delimeter) }
	else
		-- If there are many lines, sort the lines themselves
		table.sort(lines, sort_without_leading_space)
		return lines
	end
end

local heading = function(lines)
	if lines[1]:sub(1, 1) == "#" or lines[1]:sub(1, 1) == "#" then
		lines[1] = "#" .. lines[1]
	else
		lines[1] = "# " .. lines[1]
	end
	return lines
end

return {
	{
		"zdcthomas/yop.nvim",
		keys = { "gs", "<leader>#" },
		dev = true,
		config = function()
			require("yop").setup({ debug_level = 1 })
			require("yop").op_map("n", "<leader>#", heading, { linewise = true })

			vim.keymap.set({ "n", "v" }, "gs", sort, { expr = true })
		end,
	},
}
