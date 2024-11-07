local hydra = {
	config = {
		color = "pink",
		invoke_on_body = true,
		hint = {
			position = "bottom",
		},
		on_exit = function()
			vim.cmd("echo") -- clear the echo area
		end,
	},
	mode = "n",
	heads = {

		-- {
		-- 	"g",
		-- 	function()
		-- 		vim.schedule(function()
		-- 			vim.cmd("Neogit")
		-- 		end)
		-- 	end,
		-- 	{ exit = true, nowait = true },
		-- },
		{
			"n",
			function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					require("gitsigns").next_hunk()
				end)
				return "<Ignore>"
			end,
			{ expr = true },
		},
		{
			"p",
			function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					require("gitsigns").prev_hunk()
				end)
				return "<Ignore>"
			end,
			{ expr = true },
		},
		{ "a", ":Gitsigns stage_hunk<CR>", { silent = true } },
		{
			"r",
			function()
				require("gitsigns").undo_stage_hunk()
			end,
		},
		{
			"u",
			function()
				require("gitsigns").reset_hunk()
			end,
		},
		{
			"D",
			function()
				require("gitsigns").diffthis("~")
			end,
		},
		{
			"A",
			function()
				require("gitsigns").stage_buffer()
			end,
		},
		{
			"s",
			function()
				require("gitsigns").preview_hunk()
			end,
		},
		{
			"b",
			function()
				require("gitsigns").blame_line()
			end,
		},
		{
			"Q",
			function()
				require("gitsigns").setqflist("all")
			end,
			{ nowait = true },
		},
		-- {
		-- 	"B",
		-- 	function()
		-- 		gitsigns.blame_line({ full = true })
		-- 	end,
		-- },
		{
			"/",
			function()
				require("gitsigns").show()
			end,
			{ exit = true },
		}, -- show the base of the file
		{ "<Esc>", nil, { exit = true, nowait = true } },
		{ "]q", ":cn<CR>" },
		{ "[q", ":cp<CR>" },
	},
}

require("plugins.hydra.global_hydra").add_g_hydra({ key = "g", hydra = hydra, desc = "Git" })
