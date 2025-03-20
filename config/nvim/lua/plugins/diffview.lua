return {
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewRefresh",
			"DiffviewFileHistory",
		},
		keys = {
			{
				"<leader><leader>v",
				function()
					if next(require("diffview.lib").views) == nil then
						vim.cmd("DiffviewOpen")
					else
						vim.cmd("DiffviewClose")
					end
				end,
				desc = "toggle diffview",
			},
		},
		config = function()
			-- Lua
			local actions = require("diffview.actions")

			require("diffview").setup({
				enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
				view = {
					merge_tool = {
						disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
					},
				},
				keymaps = {
					disable_defaults = false, -- Disable the default keymaps
				},
			})
		end,
	},
}
