return {
	{
		"emmanueltouzery/decisive.nvim",
		keys = {
			{
				"<leader>cca",
				":lua require('decisive').align_csv({})<cr>",
				desc = "align CSV",
				silent = true,
			},
			{
				"<leader>ccA",
				":lua require('decisive').align_csv_clear({})<cr>",
				desc = "align CSV clear",
				silent = true,
			},
			{
				"[,",
				":lua require('decisive').align_csv_prev_col()<cr>",
				desc = "align CSV prev col",
				silent = true,
			},
			{
				"],",
				":lua require('decisive').align_csv_next_col()<cr>",
				desc = "align CSV next col",
				silent = true,
			},
		},
		ft = { "csv" },

		opts = {},
		-- setup text objects (optional)
		-- require('decisive').setup{}
	},
}
