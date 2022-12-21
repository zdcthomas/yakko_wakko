return {
	"junegunn/vim-easy-align",
	init = function()
		vim.keymap.set("x", "ga", function()
			require("lazy").load("vim-easy-align")
			return "<Plug>(EasyAlign)"
		end, { noremap = false, expr = true })

		vim.keymap.set("n", "ga", function()
			require("lazy").load("vim-easy-align")
			return "<Plug>(EasyAlign)"
		end, { noremap = false, expr = true })
	end,
}
