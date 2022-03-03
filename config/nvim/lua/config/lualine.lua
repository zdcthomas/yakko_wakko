local Module = {}

Module.config = {
	extensions = { "quickfix" },
	disabled_filetypes = { "startify" },
	options = {
		theme = "rose-pine",
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
	},
	sections = {
		lualine_b = { "diff" },
		lualine_a = {
			{
				"filename",
				file_status = true,
				path = 1,
				shorting_target = 40,
			},
		},
		lualine_c = { "require'lsp-status'.status()" },
		lualine_x = { "location" },
		lualine_y = {},
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
		lualine_z = { "buffers" },
	},
}

Module.setup = function()
	require("lualine").setup(Module.config)
end

return Module
