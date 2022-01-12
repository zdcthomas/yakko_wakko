-- This file is for configs that are short. It's kind of dumb to seperate these
-- out not into their own files but for now it's what I'm trying.
local Config = {}

function Config.lualine()
	-- local custom_gruvbox = require("lualine.themes.gruvbox")
	-- print(vim.inspect(custom_gruvbox)) Change the background of lualine_c section for normal mode require("lualine").setup({
	-- 	options = { theme = custom_gruvbox },
	-- })
	local config = {
		extensions = { "quickfix" },
		disabled_filetypes = { "startify" },
		options = {
			theme = "rose-pine",
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = {
				{
					"filename",
					file_status = true,
					path = 1,
				},
			},
			lualine_c = { "diff", "require'lsp-status'.status()" },
			lualine_x = {},
			lualine_y = { "branch" },
			lualine_z = { { "filetype", colored = false } },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "diff" },
			lualine_y = {},
			lualine_z = {},
		},
	}
	require("lualine").setup(config)
end

function Config.rose_pine()
	vim.g.rose_pine_inactive_background = true
	vim.g.rose_pine_bold_vertical_split_line = true

	require("rose-pine").set("moon")
end

function Config.venn()
	-- enable or disable keymappings for venn
	function _G.toggle_venn()
		local venn_enabled = vim.inspect(vim.b.venn_enabled)
		if venn_enabled == "nil" then
			print("venn mode activated!")
			vim.cmd("LspStop")
			vim.b.venn_enabled = true
			vim.cmd([[setlocal ve=all]])
			-- draw a line on HJKL keystokes
			vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<cr>", { noremap = true })
			vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<cr>", { noremap = true })
			vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<cr>", { noremap = true })
			vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<cr>", { noremap = true })
			-- draw a box by pressing "f" with visual selection
			vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<cr>", { noremap = true })
		else
			print("venn mode disengaged!")
			vim.cmd("LspStart")
			vim.cmd([[setlocal ve=]])
			vim.cmd([[mapclear <buffer>]])
			vim.b.venn_enabled = nil
		end
	end
	-- toggle keymappings for venn using <leader>v
	vim.api.nvim_set_keymap("n", "<leader>v", ":lua toggle_venn()<cr>", { silent = true, noremap = true })
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

	vim.api.nvim_set_keymap("n", "crs", ":Snek<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("x", "crs", ":Snek<CR>", { noremap = true, silent = true })

	vim.api.nvim_set_keymap("n", "crp", ":Pascal<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("x", "crp", ":Pascal<CR>", { noremap = true, silent = true })

	vim.api.nvim_set_keymap("n", "crc", ":Camel<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("x", "crc", ":Camel<CR>", { noremap = true, silent = true })

	vim.api.nvim_set_keymap("n", "crk", ":Kebab<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("x", "crk", ":Kebab<CR>", { noremap = true, silent = true })
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
	vim.cmd([[
    command! -nargs=? -complete=dir Explore Dirvish <args>
    command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
    command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
  ]])
	vim.g.dirvish_mode = ":sort | sort ,^.*[^/]$, r"
end

function Config.md_links()
	require("follow-md-links")
	vim.api.nvim_set_keymap("", "<bs>", ":edit #<cr>", { noremap = true, silent = true })
end

function Config.easy_align()
	vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", { noremap = false })
	vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", { noremap = false })
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
		keymaps = {
			["n <leader>gn"] = '<cmd>lua require"gitsigns.actions".next_hunk()<CR>',
			["n <leader>gp"] = '<cmd>lua require"gitsigns.actions".prev_hunk()<CR>',
			["n <leader>ga"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
			["v <leader>ga"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
			["n <leader>gr"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
			["n <leader>gu"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
			["v <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
			["n <leader>gs"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
			["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
			["n <leader>gc"] = '<cmd>lua require"gitsigns".setqflist("all")<CR>',
			["o ih"] = ":<C-U>Gitsigns select_hunk<CR>",
			["x ih"] = ":<C-U>Gitsigns select_hunk<CR>",
		},
	})
end

return Config
