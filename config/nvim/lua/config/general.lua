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
			enabled = true,
			backend = { "builtin", "telescope", "nui" },
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
	if not PluginIsLoaded("hydra.nvim") then
		local function toggle_venn()
			local venn_enabled = vim.inspect(vim.b.venn_enabled)
			if venn_enabled == "nil" then
				print("venn mode activated!")
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
				vim.cmd([[setlocal ve=]])
				vim.cmd([[mapclear <buffer>]])
				vim.b.venn_enabled = nil
			end
		end
		vim.keymap.set("n", "<leader>v", toggle_venn, { silent = true, desc = "Toggle Venn mode" })
	else
		local Hydra = Pquire("hydra")
		if not Hydra then
			vim.notify("Hydra not found in Telescope hydra config!", "Error")
			return
		end
		local hint = [[
		Arrow
    ^ ^ _K_ ^ ^   _f_: box it
    _H_ ^ ^ _L_
    ^ ^ _J_ ^ ^   _<Esc>_
    ]]

		local hydra = Hydra({
			name = "Draw Diagram",
			hint = hint,
			config = {
				color = "pink",
				invoke_on_body = true,
				hint = {
					border = "rounded",
				},
				on_enter = function()
					vim.o.virtualedit = "all"
				end,
			},
			mode = "n",
			heads = {
				{ "H", "<C-v>h:VBox<CR>" },
				{ "J", "<C-v>j:VBox<CR>" },
				{ "K", "<C-v>k:VBox<CR>" },
				{ "L", "<C-v>l:VBox<CR>" },
				{ "f", ":VBox<CR>", { mode = "v" } },
				{ "<Esc>", nil, { exit = true } },
			},
		})
		require("config.hydra").add_g_hydra({ key = "v", hydra = hydra, desc = "Venn" })
	end
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
	vim.g.dirvish_mode = ":sort | sort ,^.*[^/]$, r "
end

function Config.md_links()
	require("follow-md-links")
	vim.keymap.set("", "<bs>", ":edit #<cr>", { silent = true })
end

function Config.easy_align()
	vim.keymap.set("x", "ga", "<Plug>(EasyAlign)", { noremap = false })
	vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { noremap = false })
end

return Config
