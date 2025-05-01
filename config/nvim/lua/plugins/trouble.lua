return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			follow = false, -- Follow the current item
			auto_preview = false, -- automatically open preview when on an item
			preview = {
				type = "float",
				-- when a buffer is not yet loaded, the preview window will be created
				-- in a scratch buffer with only syntax highlighting enabled.
				-- Set to false, if you want the preview to always be a real loaded buffer.
				border = "rounded",
				relative = "cursor",
				scratch = true,
			},
			modes = {
				preview_float = {
					mode = "diagnostics",
					preview = {
						type = "float",
						border = "rounded",
						title = "Preview",
						title_pos = "center",
						position = { 0, -2 },
						size = { width = 0.3, height = 0.3 },
						zindex = 200,
					},
				},
			},
		},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
		},
		cmd = { "Trouble" },
	},
}
