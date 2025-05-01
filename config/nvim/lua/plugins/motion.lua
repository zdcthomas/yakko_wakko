return {
	-- {
	-- 	"jinh0/eyeliner.nvim",
	-- 	-- Shows highlight of unique words when using `f`/`t`
	-- 	-- lazy = false,
	-- 	config = function()
	-- 		require("eyeliner").setup({
	-- 			-- show highlights only after keypress
	-- 			highlight_on_key = true,
	--
	-- 			-- dim all other characters if set to true (recommended!)
	-- 			dim = true,
	--
	-- 			-- set the maximum number of characters eyeliner.nvim will check from
	-- 			-- your current cursor position; this is useful if you are dealing with
	-- 			-- large files: see https://github.com/jinh0/eyeliner.nvim/issues/41
	-- 			max_length = 9999,
	--
	-- 			-- filetypes for which eyeliner should be disabled;
	-- 			-- e.g., to disable on help files:
	-- 			-- disabled_filetypes = {"help"}
	-- 			disabled_filetypes = {},
	--
	-- 			-- buftypes for which eyeliner should be disabled
	-- 			-- e.g., disabled_buftypes = {"nofile"}
	-- 			disabled_buftypes = {},
	--
	-- 			-- add eyeliner to f/F/t/T keymaps;
	-- 			-- see section on advanced configuration for more information
	-- 			default_keymaps = true,
	-- 		})
	-- 	end,
	-- },
	{
		"mizlan/iswap.nvim",
		cmd = {
			"ISwap",
			"ISwapWith",
			"ISwapNodeWith",
			"ISwapNode",
			"ISwapWithRight",
			"ISwapWithLeft",
			"ISwapNodeWithRight",
			"ISwapNodeWithLeft",
		},
		keys = {
			{
				"<leader>sh",
				":ISwapWithLeft<CR>",
				desc = "[ s ]wap left",
				silent = true,
			},
			{
				"<leader>sl",
				":ISwapWithRight<CR>",
				desc = "[ s ]wap right",
				silent = true,
			},
			{
				"<leader>ss",
				":ISwap<CR>",
				desc = "[ s ]wap mode",
				silent = true,
			},
			{
				"<leader>s<cr>",
				":ISwap<CR>",
				desc = "[ s ]wap current with selection",
				silent = true,
			},
			{
				"<leader>sn",
				":ISwapNodeWith<CR>",
				desc = "[ s ]wap current [n]ode with selection",
				silent = true,
			},
		},
		opts = {
			flash_style = false,
			move_cursor = true,
		},
	},
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
