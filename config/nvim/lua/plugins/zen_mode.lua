return {
	{
		"folke/zen-mode.nvim",
		cmd = {
			"ZenMode",
		},
		opts = {
			window = {
				width = 135,
				backdrop = 1,
			},
		},
	},
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		cmd = { "NoNeckPain" },
		opts = {
			buffers = {
				scratchPad = {
					-- set to `false` to
					-- disable auto-saving
					enabled = true,
					-- set to `nil` to default
					-- to current working directory
					location = "~/Irulan/wiki/scratch",
					fileName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
				},
				bo = {
					filetype = "md",
				},
			},
		},
	},
}
