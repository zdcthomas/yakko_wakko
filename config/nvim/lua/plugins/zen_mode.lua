return {
	"folke/zen-mode.nvim",
	cmd = {
		"ZenMode",
	},
	config = function()
		require("zen-mode").setup({
			window = {
				width = 135,
				backdrop = 1,
			},
		})
	end,
}
