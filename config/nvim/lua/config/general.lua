-- This file is for configs that are short. It's kind of dumb to seperate these
-- out not into their own files but for now it's what I'm trying.
local Config = {}

-- These are all old configs, that are just kept around for posterity

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
	-- if not PluginIsLoaded("hydra.nvim") then
	-- local function toggle_venn()
	-- 	local venn_enabled = vim.inspect(vim.b.venn_enabled)
	-- 	if venn_enabled == "nil" then
	-- 		print("venn mode activated!")
	-- 		vim.b.venn_enabled = true
	-- 		vim.cmd([[setlocal ve=all]])
	-- 		-- draw a line on HJKL keystokes
	-- 		vim.keymap.set("n", "J", "<C-v>j:VBoxD<cr>", { buffer = true })
	-- 		vim.keymap.set("n", "K", "<C-v>k:VBoxD<cr>", { buffer = true })
	-- 		vim.keymap.set("n", "L", "<C-v>l:VBoxD<cr>", { buffer = true })
	-- 		vim.keymap.set("n", "H", "<C-v>h:VBoxD<cr>", { buffer = true })
	-- 		-- draw a box by pressing "f" with visual selection
	-- 		vim.keymap.set("v", "f", ":VBoxD<cr>", { buffer = true })
	-- 	else
	-- 		print("venn mode disengaged!")
	-- 		vim.cmd([[setlocal ve=]])
	-- 		vim.cmd([[mapclear <buffer>]])
	-- 		vim.b.venn_enabled = nil
	-- 	end
	-- end
	-- vim.keymap.set("n", "<leader>v", toggle_venn, { silent = true, desc = "Toggle Venn mode" })
	-- else
	-- end
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

return Config
