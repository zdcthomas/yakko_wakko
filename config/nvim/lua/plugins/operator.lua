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

local function search(lines)
	-- Multiple lines can't be searched for
	if #lines > 1 then
		return
	end
	require("telescope.builtin").grep_string({ search = lines[1] })
end

return {
	{
		"zdcthomas/yop.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		keys = { "gs", "<leader>f" },
		config = function()
			require("yop").setup({ debug_level = 1 })
			require("yop").op_map("n", "gs", sort)
			require("yop").op_map("n", "<leader>f", search)
		end,
	},
}
