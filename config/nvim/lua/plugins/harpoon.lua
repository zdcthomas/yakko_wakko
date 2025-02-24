local keys = {}
for i = 1, 9, 1 do
	table.insert(keys, i, {
		"<leader>" .. i,
		function()
			require("harpoon.ui").nav_file(i)
		end,
		desc = "Harpoon to file: " .. i,
	})
end

vim.list_extend(keys, {
	{
		"<leader>ha",
		function()
			require("harpoon.mark").add_file()
		end,
		desc = "[h]arpoon [a]dd a file",
	},
	{
		"<leader>hh",
		function()
			require("harpoon.ui").toggle_quick_menu()
		end,
		desc = "[h]arpoon [a]dd a file",
	},
})

return {
	{
		"theprimeagen/harpoon",
		keys = keys,
		opts = {},
	},
}
