return {
	{
		"nvim-treesitter/nvim-treesitter",
		dev = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
					max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
					min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
					line_numbers = true,
					multiline_threshold = 20, -- Maximum number of lines to show for a single context
					trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
					mode = "topline", -- Line used to calculate context. Choices: 'cursor', 'topline'
					-- Separator between context and content. Should be a single character string, like '-'.
					-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
					separator = "-",
					zindex = 20, -- The Z-index of the context window
					on_attach = function(bufnr)
						if vim.fn.winheight(0) < 25 then
							return false
						end
						local fts = { rust = true }
						return fts[vim.bo[bufnr].filetype] or false
					end,
				},
			},
			{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		opts = {
			indent = { enable = true },
			autopairs = { enable = true },
			auto_install = false,
			sync_install = false,
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
			refactor = {
				highlight_definitions = {
					enable = true,
					-- Set to false if you have an `updatetime` of ~100.
					clear_on_cursor_move = true,
				},
			},
			context_commentstring = {
				enable = true,
			},
			-- TODO: Figure out if this is slowing this down
			ensure_installed = {
				"bash",
				"comment",
				"dockerfile",
				"fennel",
				"fish",
				"gleam",
				"go",
				"gomod",
				"graphql",
				-- "help",
				"html",
				"http",
				"javascript",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"nix",
				"norg",
				"org",
				"python",
				"regex",
				"ruby",
				"rust",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "org" },
			},
		},
	},
}
