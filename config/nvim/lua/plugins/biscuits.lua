return {

	{
		"code-biscuits/nvim-biscuits",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			-- run = ":TSUpdate",
		},
		config = function()
			require("nvim-biscuits").setup({
				cursor_line_only = true,
			})
		end,
	},
}
