local Module = {}

Module.setup_keymaps = function()
	vim.keymap.set("n", "-", "<cmd>Neotree reveal<cr>", {})
end

local function setup_diagnostic_hl()
	vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
	vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
	vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
end

local filesystem_config = {
	bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
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
	-- hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
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
			["/"] = false,
			["D"] = "fuzzy_finder_directory",
			["f"] = "filter_on_submit",
			["<c-x>"] = "clear_filter",
			["[g"] = "prev_git_modified",
			["]g"] = "next_git_modified",

			["h"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" and node:is_expanded() then
					require("neo-tree.sources.filesystem").toggle_directory(state, node)
				else
					require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
				end
			end,
			["l"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" then
					if not node:is_expanded() then
						require("neo-tree.sources.filesystem").toggle_directory(state, node)
					elseif node:has_children() then
						require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
					end
				end
			end,
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
		sources = {
			"filesystem",
			"buffers",
			"git_status",
			"diagnostics",
			-- ...and any additional source
		},
		diagnostics = {
			autopreview = true, -- Whether to automatically enable preview mode
			autopreview_config = { use_float = true }, -- Config table to pass to autopreview (for example `{ use_float = true }`)
		},
		sort_function = nil, -- use a custom function for sorting files and directories in the tree
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
				["q"] = false,
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
end

return Module
