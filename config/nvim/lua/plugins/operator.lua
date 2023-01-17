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

return {
	{
		"zdcthomas/yop.nvim",
		keys = "gs",
		dev = true,
		config = function()
			require("yop").setup({ debug_level = 1 })

			vim.keymap.set({ "n", "v" }, "gs", function()
				return require("yop").operate(function(lines, _)
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
				end, false)
			end, { expr = true })
		end,
	},
}
