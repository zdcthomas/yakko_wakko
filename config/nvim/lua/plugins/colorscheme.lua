return {
	{
		"nyngwang/nvimgelion",
		config = function()
			vim.api.nvim_create_autocmd({ "ColorScheme", "FileType" }, {
				callback = function()
					vim.cmd([[
            hi IndentBlanklineChar gui=nocombine guifg=#444C55
            hi IndentBlanklineSpaceChar gui=nocombine guifg=#444C55
            hi IndentBlanklineContextChar gui=nocombine guifg=#FB5E2A
            hi IndentBlanklineContextStart gui=underline guisp=#FB5E2A
          ]])
				end,
			})
			-- do whatever you want for further customization~
		end,
	},

	{
		"savq/melange-nvim",
		priority = 1000,
		config = function()
			-- vim.cmd.colorscheme("melange")
		end,
	},
	{
		"sainnhe/everforest",
		priority = 1000,
		config = function()
			vim.g.everforest_diagnostic_virtual_text = "colored"
			vim.g.everforest_enable_italic = 1
			vim.g.everforest_transparent_background = 2
		end,
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				compile = true, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				colors = { -- add/modify theme and palette colors
					palette = {},
					theme = {
						wave = {},
						lotus = {},
						dragon = {},
						all = {
							ui = {
								float = {
									bg = "none",
								},
								bg_gutter = "none",
							},
						},
					},
				},
				overrides = function(colors) -- add/modify highlights
					return {}
				end,
				theme = "wave", -- Load "wave" theme when 'background' option is not set
				background = { -- map the value of 'background' option to a theme
					dark = "wave", -- try "dragon" !
					light = "lotus",
				},
			})

			-- vim.cmd.colorscheme("kanagawa")
		end,
	},
	{
		"zootedb0t/citruszest.nvim",
		priority = 1000,
	},
}
