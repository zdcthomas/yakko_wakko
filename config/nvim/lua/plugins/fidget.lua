return {
	{
		"j-hui/fidget.nvim",
		opts = {
			progress = {
				display = {
					progress_icon = { pattern = "meter", period = 1 },
				},
			},

			-- Options related to notification subsystem
			notification = {
				view = {
					stack_upwards = false, -- Display notification items from bottom to top
				},

				-- Options related to the notification window and buffer
				window = {
					normal_hl = "Comment", -- Base highlight group in the notification window
					winblend = 0, -- Background color opacity in the notification window
					align = "avoid_cursor",
					relative = "editor", -- What the notification window position is relative to
					border = {
						{ "╭", "None" },
						{ "─", "None" },
						{ "╮", "None" },
						{ "│", "None" },
						{ "╯", "None" },
						{ "─", "None" },
						{ "╰", "None" },
						{ "│", "None" },
					},
				},
			},
		},
	},
}
