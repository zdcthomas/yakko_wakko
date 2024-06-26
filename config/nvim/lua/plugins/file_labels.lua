return {
	{
		"ramilito/winbar.nvim",
		event = "VimEnter", -- Alternatively, BufReadPre if we don't care about the empty file when starting with 'nvim'
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("winbar").setup({
				-- your configuration comes here, for example:
				icons = true,
				diagnostics = true,
				buf_modified = true,
				buf_modified_symbol = "M",
				-- or use an icon
				-- buf_modified_symbol = "●"
				dim_inactive = {
					enabled = false,
					highlight = "WinbarNC",
					icons = true, -- whether to dim the icons
					name = true, -- whether to dim the name
				},
			})
		end,
	},
	-- {
	-- 	"b0o/incline.nvim",
	-- 	lazy = false,
	-- 	cond = false,
	-- 	opts = {
	-- 		-- debounce_threshold = {
	-- 		-- 	falling = 50,
	-- 		-- 	rising = 10,
	-- 		-- },
	-- 		hide = {
	-- 			focused_win = true,
	-- 			only_win = true,
	-- 		},
	-- 		-- highlight = {
	-- 		-- 	groups = {
	-- 		-- 		InclineNormal = {
	-- 		-- 			default = true,
	-- 		-- 			group = "NormalFloat",
	-- 		-- 		},
	-- 		-- 		InclineNormalNC = {
	-- 		-- 			default = true,
	-- 		-- 			group = "NormalFloat",
	-- 		-- 		},
	-- 		-- 	},
	-- 		-- },
	-- 		ignore = {
	-- 			buftypes = "special",
	-- 			filetypes = {},
	-- 			floating_wins = true,
	-- 			unlisted_buffers = true,
	-- 			wintypes = "special",
	-- 		},
	-- 		render = "basic",
	-- 		window = {
	-- 			margin = {
	-- 				horizontal = 1,
	-- 				vertical = 1,
	-- 			},
	-- 			options = {
	-- 				signcolumn = "no",
	-- 				wrap = false,
	-- 			},
	-- 			padding = 1,
	-- 			padding_char = " ",
	-- 			placement = {
	-- 				horizontal = "right",
	-- 				vertical = "top",
	-- 			},
	-- 			width = "fit",
	-- 			winhighlight = {
	-- 				active = {
	-- 					EndOfBuffer = "None",
	-- 					Normal = "InclineNormal",
	-- 					Search = "None",
	-- 				},
	-- 				inactive = {
	-- 					EndOfBuffer = "None",
	-- 					Normal = "InclineNormalNC",
	-- 					Search = "None",
	-- 				},
	-- 			},
	-- 			zindex = 50,
	-- 		},
	-- 	},
	-- },
}
