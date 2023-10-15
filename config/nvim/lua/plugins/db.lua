return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod" },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" } },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		config = function()
			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
				end,
				desc = "setup cmp in dadbod ui",
			})
		end,
	},
}
