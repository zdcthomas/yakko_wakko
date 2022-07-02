local conf = {}

local _slow_to_load_in_TS = {
	".*%.ex",
	".*%.exs",
}

require("telescope.actions")
-- local local_insert_symbol_i = function(prompt_bufnr)
-- 	local action_state = require("telescope.actions.state")
-- 	local actions = require("telescope.actions")

-- 	print("prompt_bufnr", prompt_bufnr)
-- 	local symbol = action_state.get_selected_entry().value
-- 	print("telescope:9 -> action_state.get_selected_entry().value", action_state.get_selected_entry().value)
-- 	actions._close(prompt_bufnr, true)
-- 	local cursor = vim.api.nvim_win_get_cursor(0)
-- 	vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { symbol })
-- 	vim.schedule(function()
-- 		vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #symbol })
-- 	end)
-- end

local action_layout = require("telescope.actions.layout")

local bad_files = function(filepath)
	for _, v in ipairs(_slow_to_load_in_TS) do
		if filepath:match(v) then
			return false
		end
	end

	return true
end

local previewers = require("telescope.previewers")
-- Stops previewer for troublesome fts, and for biggggg files
local new_maker = function(filepath, bufnr, opts)
	opts = opts or {}
	if opts.use_ft_detect == nil then
		opts.use_ft_detect = true
	end
	opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)

	filepath = vim.fn.expand(filepath)
	vim.loop.fs_stat(filepath, function(_, stat)
		if not stat then
			return
		end
		if stat.size > 100000 then
			return
		else
			previewers.buffer_previewer_maker(filepath, bufnr, opts)
		end
	end)
end

local function fb_action(f)
	return function(b)
		require("telescope").extensions.file_browser.actions[f](b)
	end
end

function conf.setup()
	local actions = require("telescope.actions")
	local telescope = require("telescope")
	telescope.setup({
		pickers = {
			git_status = {
				initial_mode = "normal",
				git_icons = {
					added = "+",
					changed = "~",
					copied = ">",
					deleted = "-",
					renamed = "r",
					unmerged = "‡",
					untracked = "u",
				},
			},
			git_commits = {
				initial_mode = "normal",
			},
			find_files = {
				hidden = true,
				follow = true,
				sorter = require("telescope").extensions.fzf.native_fzf_sorter(),
			},
		},
		defaults = {
			mappings = {
				i = {
					["<down>"] = false,
					["<up>"] = false,
					["<c-x>"] = false,
					["<c-v>"] = false,
					["<c-t>"] = false,
					["<c-k>"] = actions.move_selection_previous,
					["<c-j>"] = actions.move_selection_next,
					["<m-j>"] = actions.select_horizontal,
					["<m-l>"] = actions.select_vertical,
					["<c-l>"] = require("telescope.actions.layout").cycle_layout_next,
					["<c-/>"] = require("telescope.actions.generate").which_key,
					["<M-p>"] = action_layout.toggle_preview,
				},
				n = {
					["<tab>"] = actions.toggle_selection,
					["<M-p>"] = action_layout.toggle_preview,
					["<s-/>"] = require("telescope.actions.generate").which_key,
					["<c-k>"] = actions.move_selection_previous,
					["<c-j>"] = actions.move_selection_next,
				},
			},
			-- sorting_strategy = "ascending",
			-- layout_strategy = "vertical",
			dynamic_preview_title = true,
			buffer_previewer_maker = new_maker,
			layout_config = {
				prompt_position = "top",
			},
			-- width = 0.95,
			-- height = 0.85,
		},
		extensions = {
			file_browser = {
				-- theme = "ivy",
				-- hijack_netrw = true,
				initial_mode = "insert",
				path = "%:p:h",
				mappings = {
					n = {
						["-"] = fb_action("goto_parent_dir"),
					},
					i = {
						["<c-p>"] = fb_action("goto_parent_dir"),
					},
				},
			},
			["ui-select"] = {
				require("telescope.themes").get_cursor({
					initial_mode = "normal",
					winblend = 20,
				}),
			},
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = false, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
	})
	telescope.load_extension("file_browser")
	telescope.load_extension("fzf")
	telescope.load_extension("ui-select")
	local default_opts = { noremap = true, silent = true }

	vim.keymap.set("n", "<leader>p", function()
		require("config.telescope").find_files()
	end, { silent = true, desc = "Find files" })
	-- vim.keymap.set(
	-- 	"n",
	-- 	"-",
	-- 	"<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>",
	-- 	default_opts
	-- )
	vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers, default_opts)
	vim.keymap.set("n", "<leader>F", require("telescope.builtin").live_grep, default_opts)
	vim.keymap.set("n", "<leader>*", require("telescope.builtin").grep_string, default_opts)
	-- vim.keymap.set("n", "<Leader>gc", ":Telescope git_status<cr>", default_opts)
	-- vim.keymap.set(
	-- 	"n",
	-- 	"<Leader>wp",
	-- 	":lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({cwd = '~/irulan/wiki'}))<cr>",
	-- 	default_opts
	-- )
end

function conf.find_files()
	require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
		results_height = 20,
		winblend = 20,
		width = 0.8,
		prompt_title = "",
		prompt_prefix = "Files>",
		previewer = false,
		borderchars = {
			{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
			prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
			results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
			preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		},
		path_display = { "smart" },
		find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
	}))
end

function conf.diagnostics()
	require("telescope.builtin").diagnostics(require("telescope.themes").get_ivy())
end

function conf.lsp_bindings_for_buffer(bufnr)
	require("packer").loader("telescope.nvim")
	local opts = { buffer = bufnr, silent = false }
	vim.keymap.set("n", "<Leader>q", require("config.telescope").diagnostics, opts)
	vim.keymap.set("n", "<Leader>/", require("telescope.builtin").lsp_document_symbols, opts)
	vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
end

return conf
