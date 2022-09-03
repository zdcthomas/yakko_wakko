require("drex.config").configure({
	icons = {
		file_default = "",
		dir_open = "",
		dir_closed = "",
		link = "",
		others = "",
	},
	colored_icons = true,
	hide_cursor = false,
	hijack_netrw = false,
	sorting = function(a, b)
		local aname, atype = a[1], a[2]
		local bname, btype = b[1], b[2]

		local aisdir = atype == "directory"
		local bisdir = btype == "directory"

		if aisdir ~= bisdir then
			return aisdir
		end

		return aname < bname
	end,
	disable_default_keybindings = false,
	keybindings = {
		["n"] = {
			["v"] = "V",
			["l"] = '<cmd>lua require("drex").expand_element()<CR>',
			["h"] = '<cmd>lua require("drex").collapse_directory()<CR>',
			["<CR>"] = function()
				local drex = require("drex")
				local line = vim.api.nvim_get_current_line()

				if require("drex.utils").is_open_directory(line) then
					drex.collapse_directory()
				else
					drex.expand_element()
				end
			end,
			["<right>"] = '<cmd>lua require("drex").expand_element()<CR>',
			["<left>"] = '<cmd>lua require("drex").collapse_directory()<CR>',
			["<2-LeftMouse>"] = '<LeftMouse><cmd>lua require("drex").expand_element()<CR>',
			["<RightMouse>"] = '<LeftMouse><cmd>lua require("drex").collapse_directory()<CR>',
			["<C-v>"] = '<cmd>lua require("drex").open_file("vs")<CR>',
			["<C-x>"] = '<cmd>lua require("drex").open_file("sp")<CR>',
			["<C-t>"] = '<cmd>lua require("drex").open_file("tabnew")<CR>',
			["<C-l>"] = '<cmd>lua require("drex").open_directory()<CR>',
			["<C-h>"] = '<cmd>lua require("drex").open_parent_directory()<CR>',
			["<F5>"] = '<cmd>lua require("drex").reload_directory()<CR>',
			["gj"] = '<cmd>lua require("drex.jump").jump_to_next_sibling()<CR>',
			["gk"] = '<cmd>lua require("drex.jump").jump_to_prev_sibling()<CR>',
			["gh"] = '<cmd>lua require("drex.jump").jump_to_parent()<CR>',
			["s"] = '<cmd>lua require("drex.actions").stats()<CR>',
			["a"] = '<cmd>lua require("drex.actions").create()<CR>',
			["d"] = '<cmd>lua require("drex.actions").delete("line")<CR>',
			["D"] = '<cmd>lua require("drex.actions").delete("clipboard")<CR>',
			["p"] = '<cmd>lua require("drex.actions").copy_and_paste()<CR>',
			["P"] = '<cmd>lua require("drex.actions").cut_and_move()<CR>',
			["r"] = '<cmd>lua require("drex.actions").rename()<CR>',
			["R"] = '<cmd>lua require("drex.actions").multi_rename("clipboard")<CR>',
			["M"] = "<cmd>DrexMark<CR>",
			["u"] = "<cmd>DrexUnmark<CR>",
			["m"] = "<cmd>DrexToggle<CR>",
			["cc"] = '<cmd>lua require("drex.actions").clear_clipboard()<CR>',
			["cs"] = '<cmd>lua require("drex.actions").open_clipboard_window()<CR>',
			["y"] = '<cmd>lua require("drex.actions").copy_element_name()<CR>',
			["Y"] = '<cmd>lua require("drex.actions").copy_element_relative_path()<CR>',
			["<C-y>"] = '<cmd>lua require("drex.actions").copy_element_absolute_path()<CR>',
		},
		["v"] = {
			["d"] = ':lua require("drex.actions").delete("visual")<CR>',
			["r"] = ':lua require("drex.actions").multi_rename("visual")<CR>',
			["M"] = ":DrexMark<CR>",
			["u"] = ":DrexUnmark<CR>",
			["m"] = ":DrexToggle<CR>",
			["y"] = ':lua require("drex.actions").copy_element_name(true)<CR>',
			["Y"] = ':lua require("drex.actions").copy_element_relative_path(true)<CR>',
			["<C-y>"] = ':lua require("drex.actions").copy_element_absolute_path(true)<CR>',
		},
	},
	on_enter = nil,
	on_leave = nil,
})
