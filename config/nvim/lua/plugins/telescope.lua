local _slow_to_load_in_TS = {
	".*%.ex",
	".*%.exs",
}

local bad_files = function(filepath)
	for _, v in ipairs(_slow_to_load_in_TS) do
		if filepath:match(v) then
			return false
		end
	end

	return true
end

-- Stops previewer for troublesome fts, and for biggggg files
local new_maker = function(filepath, bufnr, opts)
	local previewers = require("telescope.previewers")
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

local function setup()
	local actions = require("telescope.actions")
	local telescope = require("telescope")

	local action_layout = require("telescope.actions.layout")
	telescope.setup({
		pickers = {
			colorscheme = {
				enable_preview = true,
			},
			live_grep = {
				scroll_strategy = "limit",
				-- mappings = {
				-- 	i = { ["<c-f>"] = actions.to_fuzzy_refine },
				-- },
			},
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
					["<m-q>"] = false,
					["<c-f>"] = actions.to_fuzzy_refine,
					["<c-k>"] = actions.move_selection_previous,
					["<c-j>"] = actions.move_selection_next,
					["<m-j>"] = actions.select_horizontal,
					["<m-l>"] = actions.select_vertical,
					["<c-l>"] = require("telescope.actions.layout").cycle_layout_next,
					["<c-/>"] = require("telescope.actions.generate").which_key,
					["<C-o>"] = actions.send_selected_to_qflist,
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
			-- sorting_strategy = "descending",
			-- layout_strategy = "vertical",
			dynamic_preview_title = true,
			buffer_previewer_maker = new_maker,
			layout_config = {
				prompt_position = "top",
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	})
	telescope.load_extension("fzf")
end

local function find_files()
	require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
		results_height = 40,
		winblend = 30,
		width = 0.8,
		prompt_title = "",
		prompt_prefix = "ファイル>",
		previewer = false,
		path_display = { "smart" },
		find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
	}))
end

local arch = vim.loop.os_uname()
local fzf_make_command = "make"
if arch == "arch64" then
	fzf_make_command = "arch -arch64 make"
end

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = fzf_make_command },
	},
	init = function()
		local default_opts = { noremap = true, silent = true }

		vim.keymap.set("n", "<leader>p", find_files, { silent = true, desc = "Find files" })
		vim.keymap.set("n", "<leader>b", function()
			require("telescope.builtin").buffers()
		end, default_opts)
		vim.keymap.set("n", "<leader>F", function()
			require("telescope.builtin").live_grep()
		end, default_opts)
		vim.keymap.set("n", "<leader>*", function()
			require("telescope.builtin").grep_string()
		end, default_opts)
	end,
	config = function()
		setup()
	end,
}
