return {
	-- { "brooth/far.vim", cmd = { "Fardo", "Far", "Farr" } },
	{
		"cshuaimin/ssr.nvim",
		init = function()
			vim.keymap.set({ "n", "x" }, "<leader>sr", function()
				-- this require will automatically load the plugin
				require("ssr").open()
			end, { desc = "Structural Replace" })
		end,
		config = function()
			require("ssr").setup({
				min_width = 50,
				min_height = 5,
				max_width = 120,
				max_height = 25,
				keymaps = {
					close = "q",
					next_match = "n",
					prev_match = "N",
					replace_confirm = "<cr>",
					replace_all = "<leader><cr>",
				},
			})
		end,
	},
}
