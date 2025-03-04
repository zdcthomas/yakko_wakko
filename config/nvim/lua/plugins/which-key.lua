return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
		},
		config = function()
			local wk = require("which-key")
			wk.setup()
			wk.add({
				{ "<leader>l", group = "lsp" }, -- group
				{ "<leader>d", group = "dap" }, -- group
			})
		end,
		keys = {

			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
