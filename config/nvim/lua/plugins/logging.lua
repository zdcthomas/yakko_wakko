return {
	{
		"Goose97/timber.nvim",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		keys = {
			"glj",
			"glk",
			"gla",
			"glb",
		},
		config = function()
			require("timber").setup({
				keymaps = {
					insert_log_below = "glj",
					insert_log_above = "glk",
					add_log_targets_to_batch = "gla",
					insert_batch_log = "glb",
					insert_log_below_operator = "g<S-l>j",
					insert_log_above_operator = "g<S-l>k",
					insert_batch_log_operator = "g<S-l>b",
					add_log_targets_to_batch_operator = "g<S-l>a",
				},
				default_keymaps_enabled = false,
				highlight = {
					on_insert = true,
					on_add_to_batch = true,
					duration = 200,
				},
			})
		end,
	},
}
