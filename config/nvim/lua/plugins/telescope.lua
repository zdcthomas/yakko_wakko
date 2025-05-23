local live_grep_in_glob = function(glob_pattern)
	require("telescope.builtin").live_grep({
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--glob=" .. (glob_pattern or ""),
		},
	})
end
local find_it = function()
	vim.ui.input({ prompt = "Glob: ", completion = "file", default = "**/*." }, live_grep_in_glob)
end

local _slow_to_load_in_TS = {
	".*%.ex",
	".*%.exs",
}

local ignore_paths = { "target", ".git", "node_modules", ".direnv", "vendor" }

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
	local action_state = require("telescope.actions.state")
	-- actions.test = function(prompt_bufnr)
	-- 	local current_picker = action_state.get_current_picker(prompt_bufnr) -- picker state
	-- 	vim.print(current_picker)
	-- end
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
					["<c-v>"] = function(bufnr)
						local line = action_state.get_current_picker(bufnr):_get_prompt()
						-- local action_state = require("telescope.actions.state")
						vim.print(line)
					end,
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
			-- layout_config = {
			-- 	prompt_position = "top",
			-- },
		},
		extensions = {
			emoji = {
				action = function(emoji)
					-- argument emoji is a table.
					-- {name="", value="", cagegory="", description=""}

					vim.api.nvim_put({ emoji.value }, "c", false, true)
				end,
			},
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	})
	telescope.load_extension("undo")
	telescope.load_extension("emoji")
	telescope.load_extension("fzf")
end
local function find_all_files()
	local find_command = {
		"rg",
		"--files",
	}
	require("telescope.builtin").find_files({
		results_height = 40,
		width = 0.8,
		-- prompt_title = "",
		prompt_title = "ファイル>",
		-- previewer = false,
		path_display = { "smart" },
		find_command = find_command,
	})
end

local function find_files()
	local find_command = {
		"rg",
		"--files",
		"--hidden",
		-- "--no-ignore",
	}
	for _key, value in pairs(ignore_paths) do
		table.insert(find_command, #find_command + 1, "-g")
		table.insert(find_command, #find_command + 1, "!" .. value)
	end
	require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
		results_height = 40,
		width = 0.8,
		prompt_title = "",
		prompt_prefix = "ファイル>",
		previewer = false,
		path_display = { "smart" },
		find_command = find_command,
	}))
end

local arch = vim.loop.os_uname()
local fzf_make_command = "make"
if arch == "arch64" then
	fzf_make_command = "arch -arch64 make"
end

local function live_search()
	require("telescope.builtin").live_grep(require("telescope.themes").get_ivy({
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim",
		},
		prompt_title = "ウォルドはどこですか", -- I'm not funny
	}))
end

return {
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { -- note how they're inverted to above example
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{ -- lazy style key map
				"<leader>uu",
				"<cmd>Telescope undo<cr>",
				desc = "undo history",
			},
		},
		config = function()
			require("telescope").setup({
				extensions = {
					undo = {
						mappings = {
							i = {

								["<cr>"] = require("telescope-undo.actions").restore,
								["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
								["<C-cr>"] = require("telescope-undo.actions").yank_additions,
							},
							n = {
								["y"] = require("telescope-undo.actions").yank_additions,
								["Y"] = require("telescope-undo.actions").yank_deletions,
								["<cr>"] = require("telescope-undo.actions").restore,
							},
						},
					},
					-- no other extensions here, they can have their own spec too
				},
			})
			require("telescope").load_extension("undo")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"xiyaowong/telescope-emoji.nvim",
			"nvim-tree/nvim-web-devicons",
			"debugloop/telescope-undo.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = fzf_make_command },
		},
		init = function()
			local default_opts = { noremap = true, silent = true }

			vim.keymap.set("n", "<leader>p", find_files, { silent = true, desc = "Find files" })

			vim.keymap.set(
				"n",
				"<leader>F",
				live_search,
				vim.fn.extendnew({ desc = "Search expression" }, default_opts)
			)

			vim.keymap.set("n", "<leader>tp", find_all_files, { silent = true, desc = "Find all files" })

			vim.keymap.set("n", "<leader>th", function()
				require("telescope.builtin").help_tags()
			end, { silent = true, desc = "Search help tags" })

			vim.keymap.set("n", "<leader>tb", function()
				require("telescope.builtin").buffers()
			end, vim.fn.extendnew({ desc = "Search buffers" }, default_opts))

			vim.keymap.set("n", "<leader>to", function()
				require("telescope.builtin").oldfiles()
			end, vim.fn.extendnew({ desc = "Search recent files" }, default_opts))

			vim.keymap.set("n", "<leader>t*", function()
				require("telescope.builtin").grep_string()
			end, vim.fn.extendnew({ desc = "search word under cursor" }, default_opts))
		end,
		config = function()
			setup()
		end,
	},
}
