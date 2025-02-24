return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/neotest-jest",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = {
			"Neotest",
		},
		keys = {
			{
				"<leader>nr",
				function()
					require("neotest").run.run()
				end,
				desc = "[n]eotest [r]un test at cursor",
			},
			{
				"<leader>nR",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "[n]eotest [R]un tests in a file",
			},
			{
				"<leader>nw",
				function()
					require("neotest").run.run(vim.loop.cwd())
				end,
				desc = "[N]eotest [R]un tests in workspace",
			},
			{
				"<leader>nd",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "[n]eotest with [d]ap",
			},
			{
				"<leader>no",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "[n]eotest open [o]utput",
			},
			{
				"<leader>nO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "[n]eotest toggle [O]utput panel",
			},
			{
				"<leader>ns",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "[n]eotest toggle [s]ummary panel",
			},
		},
		config = function()
			require("neotest").setup({
				icons = {
					unknown = "",
					passed = "",
					failed = "",
					skipped = "",
					watching = "",
					running_animated = {
						"⠋",
						"⠙",
						"⠚",
						"⠒",
						"⠂",
						"⠂",
						"⠒",
						"⠲",
						"⠴",
						"⠦",
						"⠖",
						"⠒",
						"⠐",
						"⠐",
						"⠒",
						"⠓",
						"⠋",
					},
				},
				quickfix = {
					enabled = true,
					-- open = true,
				},
				adapters = {
					require("rustaceanvim.neotest"),
					require("neotest-jest")({
						-- jestCommand = "npx jest",
						-- cwd = function(path)
						-- 	return vim.fn.getcwd()
						-- end,
					}),
				},
			})
		end,
	},
}
