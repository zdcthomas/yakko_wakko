local drex = Pquire("drex")
if not drex then
	vim.notify("Drex not loaded", "Error")
	return
end

local elements = require("drex.elements")

-- open parent DREX buffer and focus current file
vim.keymap.set("n", "-", function()
	local path = vim.fn.expand("%:p")
	if path == "" then
		drex.open_directory_buffer() -- open at cwd
	else
		drex.open_directory_buffer(vim.fn.fnamemodify(path, ":h"))
		elements.focus_element(0, path)
	end
end, {})

require("drex.config").configure({
	keybindings = {
		["n"] = {
			["<CR>"] = elements.expand_element,
			["-"] = elements.open_parent_directory,
			["."] = function()
				local element = require("drex.utils").get_element(vim.api.nvim_get_current_line())
				local left = vim.api.nvim_replace_termcodes("<left>", true, false, true)
				vim.api.nvim_feedkeys(": " .. element .. string.rep(left, #element + 1), "n", true)
			end,

			["<c-j>"] = '<cmd>lua require("drex.actions.jump").jump_to_next_sibling()<CR>',
			["<c-k>"] = '<cmd>lua require("drex.actions.jump").jump_to_prev_sibling()<CR>',
		},
	},
})

-- Defaults
-- keybindings = {
--     ['n'] = {
--         ['v'] = 'V',
--         ['l'] = '<cmd>lua require("drex.elements").expand_element()<CR>',
--         ['h'] = '<cmd>lua require("drex.elements").collapse_directory()<CR>',
--         ['<right>'] = '<cmd>lua require("drex.elements").expand_element()<CR>',
--         ['<left>']  = '<cmd>lua require("drex.elements").collapse_directory()<CR>',
--         ['<2-LeftMouse>'] = '<LeftMouse><cmd>lua require("drex.elements").expand_element()<CR>',
--         ['<RightMouse>']  = '<LeftMouse><cmd>lua require("drex.elements").collapse_directory()<CR>',
--         ['<C-v>'] = '<cmd>lua require("drex.elements").open_file("vs")<CR>',
--         ['<C-x>'] = '<cmd>lua require("drex.elements").open_file("sp")<CR>',
--         ['<C-t>'] = '<cmd>lua require("drex.elements").open_file("tabnew", true)<CR>',
--         ['<C-l>'] = '<cmd>lua require("drex.elements").open_directory()<CR>',
--         ['<C-h>'] = '<cmd>lua require("drex.elements").open_parent_directory()<CR>',
--         ['<F5>'] = '<cmd>lua require("drex").reload_directory()<CR>',
--         ['gj'] = '<cmd>lua require("drex.actions.jump").jump_to_next_sibling()<CR>',
--         ['gk'] = '<cmd>lua require("drex.actions.jump").jump_to_prev_sibling()<CR>',
--         ['gh'] = '<cmd>lua require("drex.actions.jump").jump_to_parent()<CR>',
--         ['s'] = '<cmd>lua require("drex.actions.stats").stats()<CR>',
--         ['a'] = '<cmd>lua require("drex.actions.files").create()<CR>',
--         ['d'] = '<cmd>lua require("drex.actions.files").delete("line")<CR>',
--         ['D'] = '<cmd>lua require("drex.actions.files").delete("clipboard")<CR>',
--         ['p'] = '<cmd>lua require("drex.actions.files").copy_and_paste()<CR>',
--         ['P'] = '<cmd>lua require("drex.actions.files").cut_and_move()<CR>',
--         ['r'] = '<cmd>lua require("drex.actions.files").rename()<CR>',
--         ['R'] = '<cmd>lua require("drex.actions.files").multi_rename("clipboard")<CR>',
--         ['M'] = '<cmd>DrexMark<CR>',
--         ['u'] = '<cmd>DrexUnmark<CR>',
--         ['m'] = '<cmd>DrexToggle<CR>',
--         ['cc'] = '<cmd>lua require("drex.clipboard").clear_clipboard()<CR>',
--         ['cs'] = '<cmd>lua require("drex.clipboard").open_clipboard_window()<CR>',
--         ['y'] = '<cmd>lua require("drex.actions.text").copy_name()<CR>',
--         ['Y'] = '<cmd>lua require("drex.actions.text").copy_relative_path()<CR>',
--         ['<C-y>'] = '<cmd>lua require("drex.actions.text").copy_absolute_path()<CR>',
--     },
--     ['v'] = {
--         ['d'] = ':lua require("drex.actions.files").delete("visual")<CR>',
--         ['r'] = ':lua require("drex.actions.files").multi_rename("visual")<CR>',
--         ['M'] = ':DrexMark<CR>',
--         ['u'] = ':DrexUnmark<CR>',
--         ['m'] = ':DrexToggle<CR>',
--         ['y'] = ':lua require("drex.actions.text").copy_name(true)<CR>',
--         ['Y'] = ':lua require("drex.actions.text").copy_relative_path(true)<CR>',
--         ['<C-y>'] = ':lua require("drex.actions.text").copy_absolute_path(true)<CR>',
--     }
-- },
