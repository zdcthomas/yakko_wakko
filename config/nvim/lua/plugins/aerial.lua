return {
	{
		"stevearc/aerial.nvim",
		init = function()
			vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>")
		end,
		cmd = {
			"AerialToggle",
			"AerialPrev",
			"AerialNext",
			"AerialGo",
			"AerialInfo",
			"AerialOpen",
			"AerialClose",
			"AerialNavOpen",
			"AerialOpenAll",
			"AerialCloseAll",
			"AerialNavClose",
			"AerialNavToggle",
		},
		opts = function()
			require("telescope").load_extension("aerial")
			return {
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			}
		end,
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
