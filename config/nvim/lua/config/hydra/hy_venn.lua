local hydra_loaded, Hydra = pcall(require, "hydra")
if not hydra_loaded then
	vim.notify("Couldn't load venn hydra", "Error")
	return
end

local hint = [[
		Arrow
    ^ ^ _K_ ^ ^   _f_: box it
    _H_ ^ ^ _L_
    ^ ^ _J_ ^ ^   _<Esc>_
    ]]

return Hydra({
	name = "Draw Diagram",
	hint = hint,
	config = {
		color = "pink",
		invoke_on_body = true,
		hint = {
			border = "rounded",
		},
		on_enter = function()
			vim.o.virtualedit = "all"
			vim.cmd.PackerLoad("venn.nvim")
		end,
	},
	mode = "n",
	heads = {
		{ "H", "<C-v>h:VBoxD<CR>" },
		{ "J", "<C-v>j:VBoxD<CR>" },
		{ "K", "<C-v>k:VBoxD<CR>" },
		{ "L", "<C-v>l:VBoxD<CR>" },
		{ "f", ":VBoxD<CR>", { mode = "v" } },
		{ "F", ":VFill<CR>", { mode = "v" } },
		{ "<Esc>", nil, { exit = true } },
	},
})
