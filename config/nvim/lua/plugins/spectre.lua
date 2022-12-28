return {
	"windwp/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	init = function()
		vim.keymap.set("n", "<leader>S", function()
			require("spectre").open()
		end, {})
		vim.keymap.set("n", "<leader>sw", function()
			require("spectre").open_visual({ select_word = true })
		end, {})
		vim.keymap.set("n", "<leader>sf", function()
			require("spectre").open_file_search()
		end, {})
	end,
}
