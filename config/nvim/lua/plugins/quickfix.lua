return {
	{
		url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
		lazy = false,
		-- ft = "qf",
		config = function(opts)
			require("pqf").setup()
		end,
	},
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
}
