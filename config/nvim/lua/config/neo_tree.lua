local Module = {}

local function setup_keymaps()
	vim.keymap.set("n", "-", "<cmd>Neotree reveal<cr>", {})
end

local function setup_diagnostic_hl()
	vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
	vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
	vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
end

local filesystem_config = {
	filtered_items = {
		hide_dotfiles = false,
		hide_gitignored = false,
		hide_hidden = false, -- only works on Windows for hidden files/directories
		hide_by_name = {
			--"node_modules"
		},
		hide_by_pattern = { -- uses glob style patterns
			--"*.meta",
			--"*/src/*/tsconfig.json",
		},
		always_show = { -- remains visible even if other settings would normally hide it
			--".gitignored",
		},
		never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
			--".DS_Store",
			--"thumbs.db"
		},
		never_show_by_pattern = { -- uses glob style patterns
			--".null-ls_*",
		},
	},
	follow_current_file = false, -- This will find and focus the file in the active buffer every
	-- time the current file is changed while the tree is open.
	group_empty_dirs = true, -- when true, empty folders will be grouped together
	hijack_netrw_behavior = "open_current", -- netrw disabled, opening a directory opens neo-tree
	-- in whatever position is specified in window.position
	-- "open_current",  -- netrw disabled, opening a directory opens within the
	-- window like netrw would, regardless of window.position
	-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
	use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
	-- instead of relying on nvim autocmd events.
	window = {
		mappings = {
			["-"] = "navigate_up",
			["."] = "set_root",
			["/"] = "fuzzy_finder",
			["D"] = "fuzzy_finder_directory",
			["f"] = "filter_on_submit",
			["<c-x>"] = "clear_filter",
			["[g"] = "prev_git_modified",
			["]g"] = "next_git_modified",
		},
	},
}

local function setup_neo_tree()
	require("neo-tree").setup({
		close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		sort_case_insensitive = true, -- used when sorting files and directories in the tree
		sort_function = nil, -- use a custom function for sorting files and directories in the tree
		-- sort_function = function (a,b)
		--       if a.type == b.type then
		--           return a.path > b.path
		--       else
		--           return a.type > b.type
		--       end
		--   end , -- this sorts files and directories descendantly
		renderers = {
			directory = {
				{ "indent" },
				{ "icon" },
				{ "current_filter" },
				{
					"name",
					use_git_status_colors = true,
				},
				{
					"symlink_target",
					highlight = "NeoTreeSymbolicLinkTarget",
				},
				{ "clipboard" },
				{ "git_status" },
			},
			file = {
				{ "indent" },
				{ "icon" },
				{
					"name",
					use_git_status_colors = true,
				},
				{
					"symlink_target",
					highlight = "NeoTreeSymbolicLinkTarget",
				},
				{ "bufnr" },
				{ "clipboard" },
				{ "diagnostics", zindex = 20, align = "right" },
				{ "git_status" },
			},
		},
		default_component_configs = {
			-- indent = {
			-- 	indent_size = 2,
			-- 	padding = 1, -- extra padding on left hand side
			-- 	-- indent guides
			-- 	with_markers = true,
			-- 	indent_marker = "│",
			-- 	last_indent_marker = "└",
			-- 	highlight = "NeoTreeIndentMarker",
			-- 	-- expander config, needed for nesting files
			-- 	with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
			-- 	expander_collapsed = "",
			-- 	expander_expanded = "",
			-- 	expander_highlight = "NeoTreeExpander",
			-- },
			-- icon = {
			-- 	folder_closed = "",
			-- 	folder_open = "",
			-- 	folder_empty = "ﰊ",
			-- 	-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
			-- 	-- then these will never be used.
			-- 	default = "*",
			-- 	highlight = "NeoTreeFileIcon",
			-- },
			-- modified = {
			-- 	symbol = "[+]",
			-- 	highlight = "NeoTreeModified",
			-- },
			-- name = {
			-- 	trailing_slash = true,
			-- 	use_git_status_colors = true,
			-- 	highlight = "NeoTreeFileName",
			-- },
			-- git_status = {
			-- 	symbols = {
			-- 		-- Change type
			-- 		added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
			-- 		modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
			-- 		deleted = "✖", -- this can only be used in the git_status source
			-- 		renamed = "", -- this can only be used in the git_status source
			-- 		-- Status type
			-- 		untracked = "",
			-- 		ignored = "",
			-- 		unstaged = "",
			-- 		staged = "",
			-- 		conflict = "",
			-- 	},
			-- },
		},
		source_selector = {
			winbar = true,
			statusline = true,
		},
		window = {
			position = "current",
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<space>"] = {
					"toggle_node",
					nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
				},
				["<esc>"] = "revert_preview",
				["P"] = { "toggle_preview", config = { use_float = true } },
				["C"] = "close_node",
				["z"] = "close_all_nodes",
				--["Z"] = "expand_all_nodes",
				["a"] = {
					"add",
					-- some commands may take optional config options, see `:h neo-tree-mappings` for details
					config = {
						show_path = "relative", -- "none", "relative", "absolute"
					},
				},
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				-- ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
				["c"] = {
					"copy",
					config = {
						show_path = "relative", -- "none", "relative", "absolute"
					},
				},
				["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<"] = "prev_source",
				[">"] = "next_source",
			},
		},
		filesystem = filesystem_config,
		buffers = {
			follow_current_file = true, -- This will find and focus the file in the active buffer every
			-- time the current file is changed while the tree is open.
			group_empty_dirs = true, -- when true, empty folders will be grouped together
			show_unloaded = true,
			window = {
				mappings = {
					["bd"] = "buffer_delete",
					["<bs>"] = "navigate_up",
					["."] = "set_root",
				},
			},
		},
		git_status = {
			window = {
				mappings = {
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "noop",
					["gp"] = "noop",
					["gg"] = "noop",
				},
				popup = {
					position = { col = "100%", row = "2" },
					size = function(state)
						local root_name = vim.fn.fnamemodify(state.path, ":~")
						local root_len = string.len(root_name) + 4
						return {
							width = math.max(root_len, 50),
							height = vim.o.lines - 6,
						}
					end,
				},
			},
		},
	})
end

Module.config = function()
	vim.g.neo_tree_remove_legacy_commands = 1

	setup_diagnostic_hl()

	setup_neo_tree()

	setup_keymaps()
end

return Module