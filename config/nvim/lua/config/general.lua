-- This file is for configs that are short. It's kind of dumb to seperate these
-- out not into their own files but for now it's what I'm trying.
local Config = {}

function Config.dressing()
	require("dressing").setup({
		input = {
			enabled = true,
			default_prompt = "➤ ",
			insert_only = false,

			-- These are passed to nvim_open_win
			anchor = "SW",
			relative = "cursor",
			border = "rounded",
		},
		select = {
			enabled = false,
		},
	})
end

function Config.hardtime()
	vim.g.hardtime_default_on = 0
	vim.g.list_of_normal_keys = { "h", "j", "k", "l", "x" }
	vim.g.list_of_visual_keys = { "h", "j", "k", "l", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" }
	vim.g.list_of_insert_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" }
	vim.g.list_of_disabled_keys = {}
	vim.g.hardtime_timeout = 1000

	vim.g.hardtime_showmsg = 0
	vim.g.hardtime_ignore_buffer_patterns = { "Dirvish", "help" }
	vim.g.hardtime_ignore_quickfix = 1

	vim.g.hardtime_maxcount = 3
	vim.g.hardtime_ignore_quickfix = 1
end

function Config.kanagawa()
	require("kanagawa").setup({
		globalStatus = true, -- adjust window separators highlight for laststatus=3
	})
end

function Config.rose_pine()
	require("rose-pine").setup({
		---@usage 'main'|'moon'
		dark_variant = "moon",
		bold_vert_split = true,
		disable_float_background = false,
		groups = {
			border = "highlight_med",
			comment = "muted",
			link = "iris",
			punctuation = "subtle",

			error = "love",
			hint = "iris",
			info = "foam",
			warn = "gold",

			headings = "subtle",
			-- or set all headings at once
			-- headings = 'subtle'
		},
	})
end

function Config.venn()
	-- enable or disable keymappings for venn
	function _G.toggle_venn()
		local venn_enabled = vim.inspect(vim.b.venn_enabled)
		if venn_enabled == "nil" then
			print("venn mode activated!")
			vim.cmd("LspStop")
			vim.cmd("HardTimeOff")
			vim.b.venn_enabled = true
			vim.cmd([[setlocal ve=all]])
			-- draw a line on HJKL keystokes
			vim.keymap.set("n", "J", "<C-v>j:VBox<cr>", { buffer = true })
			vim.keymap.set("n", "K", "<C-v>k:VBox<cr>", { buffer = true })
			vim.keymap.set("n", "L", "<C-v>l:VBox<cr>", { buffer = true })
			vim.keymap.set("n", "H", "<C-v>h:VBox<cr>", { buffer = true })
			-- draw a box by pressing "f" with visual selection
			vim.keymap.set("v", "f", ":VBox<cr>", { buffer = true })
		else
			print("venn mode disengaged!")
			vim.cmd("LspStart")
			vim.cmd("HardTimeOn")
			vim.cmd([[setlocal ve=]])
			vim.cmd([[mapclear <buffer>]])
			vim.b.venn_enabled = nil
		end
	end

	-- toggle keymappings for venn using <leader>v
	vim.keymap.set("n", "<leader>v", ":lua toggle_venn()<cr>", { silent = true, desc = "Toggle Venn mode" })
end

function Config.notify()
	require("notify").setup({
		stages = "slide",
		timeout = 3000,
		-- Minimum width for notification windows
		minimum_width = 30,
		icons = {
			ERROR = "",
			WARN = "",
			INFO = "",
			DEBUG = "",
			TRACE = "✎",
		},
	})
	vim.notify = require("notify")
end

function Config.camelsnek()
	vim.g.camelsnek_alternative_camel_commands = 1

	vim.keymap.set("n", "crs", ":Snek<CR>", { silent = true, desc = "snake_case" })
	vim.keymap.set("x", "crs", ":Snek<CR>", { silent = true, desc = "snake_case" })

	vim.keymap.set("n", "crp", ":Pascal<CR>", { silent = true, desc = "PascalCase" })
	vim.keymap.set("x", "crp", ":Pascal<CR>", { silent = true, desc = "PascalCase" })

	vim.keymap.set("n", "crc", ":Camel<CR>", { silent = true, desc = "camelCase" })
	vim.keymap.set("x", "crc", ":Camel<CR>", { silent = true, desc = "camel_case" })

	vim.keymap.set("n", "crk", ":Kebab<CR>", { silent = true, desc = "kebab-case" })
	vim.keymap.set("x", "crk", ":Kebab<CR>", { silent = true, desc = "kebab-case" })
end

function Config.autopairs()
	require("nvim-autopairs").setup({
		fast_wrap = {},
		check_ts = true,
		disable_in_macro = true,
	})
end

function Config.dirvish()
	vim.g.loaded_netrwPlugin = 1
	-- vim.api.nvim_create_user_command("Explore", "Dirvish", {})
	vim.cmd([[
    command! -nargs=? -complete=dir Explore Dirvish <args>
    command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
    command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
  ]])
	vim.g.dirvish_mode = ":sort | sort ,^.*[^/]$, r"
end

function Config.md_links()
	require("follow-md-links")
	vim.keymap.set("", "<bs>", ":edit #<cr>", { silent = true })
end

function Config.easy_align()
	vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { noremap = false })
	vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { noremap = false })
end

function Config.git_signs()
	require("gitsigns").setup({
		signs = {
			add = { hl = "GitSignsAdd", text = ">", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
			change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
			delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			topdelete = {
				hl = "GitSignsDelete",
				text = "‾",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = "~",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
		numhl = true,
		on_attach = function(bufnr)
			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			local gs = package.loaded.gitsigns

			map({ "n", "v" }, "<leader>ga", ":Gitsigns stage_hunk<cr>", { desc = "Stage hunk under cursor" })
			map("n", "<leader>gA", gs.stage_buffer, { desc = "Stage entire buffer" })
			map("n", "<leader>gr", gs.undo_stage_hunk, { desc = "Undo changes to a hunk" })

			map({ "n", "v" }, "<leader>gu", ":Gitsigns reset_hunk<cr>", { desc = "Undo the staging of a hunk" })
			map("n", "<leader>gU", gs.reset_buffer, { desc = "Undo the staging of buffer" })

			map("n", "<leader>gn", gs.next_hunk, { desc = "Next hunkk" })
			map("n", "<leader>gp", gs.prev_hunk, { desc = "Previous hunk" })

			map("n", "<leader>gs", gs.preview_hunk, { desc = "Show hunk diff" })

			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, { desc = "Show full git blame" })
			map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "show git blame line" })

			map("n", "<leader>gd", function()
				gs.diffthis("~")
			end, { desc = "Show side by side git diff" })

			map("n", "<leader>gtd", gs.toggle_deleted, { desc = "show deleted" })

			map("n", "<leader>gc", function()
				gs.setqflist("all")
			end, { desc = "Send changes to quickfix list" })

			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "expand visual selection to hunk" })
		end,
	})
end

return Config
