return {
	{
		"jbyuki/venn.nvim",
		cmd = {
			"VBox",
			"VBoxD",
			"VBoxH",
			"VBoxO",
			"VFill",
			"VBoxDO",
			"VBoxHO",
		},
		init = function()
			local menu = require("plugins.hydra.global_hydra")
			local venn_hint = [[
 Select region with <C-v>  
 _f_: surround it with box 
 _F_: Really surround it with box 
 _<Esc>_
 
 Arrow^^^^^^   Arrow^^^^^^
 ^ ^ _K_ ^ ^   ^ ^   _<c-k>_ ^ ^
 _H_ ^ ^ _L_   _<c-h>_ ^ ^ _<c-l>_
 ^ ^ _J_ ^ ^   ^ ^   _<c-j>_ ^ ^
    ]]

			local venn = {
				name = "Draw Diagram",
				hint = venn_hint,
				config = {
					color = "pink",
					invoke_on_body = true,
					hint = {
						border = "rounded",
						position = "top-right",
					},
					on_enter = function()
						vim.o.virtualedit = "all"
					end,
				},
				mode = "n",
				-- body = "<leader>d",
				heads = {
					{ "H", "<C-v>h:VBox<CR>" },
					{ "J", "<C-v>j:VBox<CR>" },
					{ "K", "<C-v>k:VBox<CR>" },
					{ "L", "<C-v>l:VBox<CR>" },
					{ "<c-h>", "<C-v>h:VBoxD<CR>" },
					{ "<c-j>", "<C-v>j:VBoxD<CR>" },
					{ "<c-k>", "<C-v>k:VBoxD<CR>" },
					{ "<c-l>", "<C-v>l:VBoxD<CR>" },
					{ "f", ":VBox<CR>", { mode = "v" } },
					{ "F", ":VBoxD<CR>", { mode = "v" } },
					{ "<Esc>", nil, { exit = true } },
				},
			}
			menu.add_g_hydra({ key = "v", hydra = venn, desc = "Draw diagrams" })
		end,
	},
}
