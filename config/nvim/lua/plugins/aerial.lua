return {
	{
		"bassamsdata/namu.nvim",
		keys = {

			{
				"<leader>A",
				":Namu watchtower<cr>",
				{
					desc = "Namu open symbols",
					silent = true,
				},
			},
		},
		cmd = { "Namu" },
		config = function()
			require("namu").setup({
				-- Enable the modules you want
				namu_symbols = {
					enable = true,
					options = {
						movement = {
							next = { "<C-n>", "j" }, -- Support multiple keys
							previous = { "<C-p>", "k" }, -- Support multiple keys
							close = { "<ESC>" }, -- close mapping
							select = { "<CR>" }, -- select mapping
						},
					}, -- here you can configure namu
				},
				-- Optional: Enable other modules if needed
				ui_select = { enable = false }, -- vim.ui.select() wrapper
				colorscheme = {
					enable = false,
					options = {
						-- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
						persist = true, -- very efficient mechanism to Remember selected colorscheme
						write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
					},
				},
			})
			-- === Suggested Keymaps: ===
		end,
	},
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
