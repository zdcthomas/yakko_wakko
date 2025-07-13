return {
	"nvim-lualine/lualine.nvim",
	event = "BufReadPost",
	opts = {
		extensions = { "quickfix", "man", "oil", "lazy" },
		disabled_filetypes = { "startify" },
		options = {
			theme = "auto",
			section_separators = { left = "", right = "" },

			refresh = {
				statusline = 200, -- Note these are in mili second and default is 1000
			},
			component_separators = { left = "", right = "" },
			globalstatus = true,
		},
		sections = {
			lualine_a = {
				{
					"filename",
					file_status = true,
					path = 1,
					shorting_target = 40,
				},
			},
			lualine_b = { "diff" },
			lualine_c = {
				{
					require("lazy.status").updates,
					cond = require("lazy.status").has_updates,
					color = { fg = "#ff9e64" },
				},
				{
					"diagnostics",
					-- sources = { "nvim_lsp", "nvim_diagnositc" },
					colored = true,
				},
			},
			lualine_x = { "location", "progress" },
			lualine_y = { "encoding" },
			lualine_z = { { "filetype", colored = false } },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "diff" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "windows" },
		},
	},
}
