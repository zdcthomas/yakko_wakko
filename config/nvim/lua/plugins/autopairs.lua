return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			fast_wrap = {},
			check_ts = true,
			disable_in_macro = true,
		})
	end,
}
