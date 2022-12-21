local Module = {}

local Hydra, hydra_loaded = pcall(require, "hydra")
if not hydra_loaded then
	vim.notify("Hydra not found in Telescope hydra config!", "Error")
	return
end

local hint = [[
		Arrow
    ^ ^ _K_ ^ ^   _f_: box it
    _H_ ^ ^ _L_
    ^ ^ _J_ ^ ^   _<Esc>_
    ]]

Module.hydra = Hydra({
	hint = hint,
	config = {
		color = "pink",
		invoke_on_body = true,
		hint = {
			border = "rounded",
		},
		on_enter = function()
			vim.o.virtualedit = "all"
		end,
	},
	mode = "n",
	heads = {
		-- { "H", "<C-v>h:VBox<CR>" },
		-- { "J", "<C-v>j:VBox<CR>" },
		-- { "K", "<C-v>k:VBox<CR>" },
		-- { "L", "<C-v>l:VBox<CR>" },
		-- { "f", ":VBox<CR>", { mode = "v" } },
		-- { "<Esc>", nil, { exit = true } },
	},
})

return Module
