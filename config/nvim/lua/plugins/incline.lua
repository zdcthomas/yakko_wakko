return {
	"b0o/incline.nvim",
	lazy = false,
	cond = false,
	config = function()
		require("incline").setup({
			-- debounce_threshold = {
			-- 	falling = 50,
			-- 	rising = 10,
			-- },
			hide = {
				focused_win = true,
				only_win = true,
			},
			-- highlight = {
			-- 	groups = {
			-- 		InclineNormal = {
			-- 			default = true,
			-- 			group = "NormalFloat",
			-- 		},
			-- 		InclineNormalNC = {
			-- 			default = true,
			-- 			group = "NormalFloat",
			-- 		},
			-- 	},
			-- },
			ignore = {
				buftypes = "special",
				filetypes = {},
				floating_wins = true,
				unlisted_buffers = true,
				wintypes = "special",
			},
			render = "basic",
			window = {
				margin = {
					horizontal = 1,
					vertical = 1,
				},
				options = {
					signcolumn = "no",
					wrap = false,
				},
				padding = 1,
				padding_char = " ",
				placement = {
					horizontal = "right",
					vertical = "top",
				},
				width = "fit",
				winhighlight = {
					active = {
						EndOfBuffer = "None",
						Normal = "InclineNormal",
						Search = "None",
					},
					inactive = {
						EndOfBuffer = "None",
						Normal = "InclineNormalNC",
						Search = "None",
					},
				},
				zindex = 50,
			},
		})
	end,
}
