local conf = {}

-- local function prequire(...)
-- 	local status, lib = pcall(require, ...)
-- 	if status then
-- 		return lib
-- 	end
-- 	return nil
-- end
-- local actions = prequire("telescope.actions")
-- local action_state = prequire("telescope.actions.state")
-- local previewers = prequire("telescope.previewers")

local _slow_to_load_in_TS = { ".*%.ex", ".*%.exs" } -- Put all filetypes that slow you down in this array

local local_insert_symbol_i = function(prompt_bufnr)
	local action_state = require("telescope.actions.state")
	local actions = require("telescope.actions")

	print("prompt_bufnr", prompt_bufnr)
	local symbol = action_state.get_selected_entry().value
	print("telescope:9 -> action_state.get_selected_entry().value", action_state.get_selected_entry().value)
	actions._close(prompt_bufnr, true)
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { symbol })
	vim.schedule(function()
		vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #symbol })
	end)
end

local bad_files = function(filepath)
	for _, v in ipairs(_slow_to_load_in_TS) do
		if filepath:match(v) then
			return false
		end
	end

	return true
end

local new_maker = function(filepath, bufnr, opts)
	local previewers = require("telescope.previewers")

	opts = opts or {}
	if opts.use_ft_detect == nil then
		opts.use_ft_detect = true
	end
	opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)
	previewers.buffer_previewer_maker(filepath, bufnr, opts)
end

function conf.setup()
	local actions = require("telescope.actions")
	local telescope = require("telescope")
	telescope.setup({
		pickers = {
			find_files = {
				hidden = true,
				follow = true,
				mappings = {
					i = {
						["<c-i>"] = local_insert_symbol_i,
						["<c-k>"] = actions.move_selection_previous,
						["<c-j>"] = actions.move_selection_next,
						["<tab>"] = actions.toggle_selection,
					},
				},
			},
		},
		defaults = {
			sorting_strategy = "ascending",
			layout_strategy = "vertical",
			dynamic_preview_title = true,
			buffer_previewer_maker = new_maker,
			layout_config = {
				width = 0.95,
				height = 0.85,
				-- preview_cutoff = 120,
				horizontal = {
					preview_width = function(_, cols, _)
						if cols > 200 then
							return math.floor(cols * 0.4)
						else
							return math.floor(cols * 0.6)
						end
					end,
					prompt_position = "top",
				},

				vertical = {
					width = 0.9,
					height = 0.95,
					prompt_position = "top",
					preview_height = 0.5,
				},

				flex = {
					horizontal = {
						preview_width = 0.9,
					},
				},
			},
		},
		extensions = {
			file_browser = {
				theme = "ivy",
				-- mappings = {
				-- 	["i"] = {
				-- 		-- your custom insert mode mappings
				-- 	},
				-- 	["n"] = {
				-- 		-- your custom normal mode mappings
				-- 	},
				-- },
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
	-- To get fzf loaded and working with telescope, you need to call
	-- load_extension, somewhere after setup function:
	require("telescope").load_extension("fzf")
	require("telescope").load_extension("file_browser")
	require("telescope").load_extension("ui-select")
	local default_opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap(
		"n",
		"<leader>p",
		"<cmd>lua require'telescope.builtin'.find_files( require('telescope.themes').get_dropdown({ path_display = {'smart'}, find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}))<cr>",
		default_opts
	)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>n",
		"<cmd>lua require 'telescope'.extensions.file_browser.file_browser()<CR>",
		{ noremap = true }
	)
	vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>Telescope buffers<cr>", default_opts)
	vim.api.nvim_set_keymap("n", "<Leader>F", ":Telescope live_grep<cr>", default_opts)
	vim.api.nvim_set_keymap("n", "<Leader>*", ":Telescope grep_string<cr>", default_opts)
	vim.api.nvim_set_keymap(
		"n",
		"<Leader>wp",
		":lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({cwd = '~/irulan/wiki'}))<cr>",
		default_opts
	)
end

function conf.lsp_bindings_for_buffer(bufnr)
	require("packer").loader("telescope.nvim")
	local opts = { silent = false, noremap = true }
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	buf_set_keymap(
		"n",
		"<Leader>q",
		'<Cmd>lua require("telescope.builtin").diagnostics(require("telescope.themes").get_ivy())<cr>',
		opts
	)
	buf_set_keymap("n", "<Leader>/", '<Cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>', opts)
	buf_set_keymap("n", "gd", '<Cmd>lua require("telescope.builtin").lsp_definitions()<cr>', opts)
end

return conf
