return {
	{
		"folke/flash.nvim",
		-- event = "VeryLazy",
		opts = {
			label = {
				-- style = "overlay",
				uppercase = false,
				-- rainbow = {
				-- 	enabled = true,
				-- 	shade = 3,
				-- },
			},
			modes = {
				search = {
					enabled = false,
				},
				char = {
					enabled = false,
					keys = {},
				},
			},
		},

		keys = {
			{
				"<leader>/",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			-- {
			-- 	"S",
			-- 	mode = { "n", "x", "o" },
			-- 	function()
			-- 		require("flash").treesitter()
			-- 	end,
			-- 	desc = "Flash Treesitter",
			-- },
			-- {
			-- 	"\\",
			-- 	mode = { "n", "x", "o" },
			-- 	function()
			-- 		require("flash").jump()
			-- 	end,
			-- 	desc = "Flash",
			-- },
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
}
