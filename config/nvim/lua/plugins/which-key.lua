return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
		},
		keys = {

			-- {
			-- 	"z",
			-- 	function()
			-- 		require("which-key").show({
			-- 			keys = "z",
			-- 			loop = true, -- this will keep the popup open until you hit <esc>})
			-- 		})
			-- 	end,
			-- 	desc = "Window thing test",
			-- },
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
