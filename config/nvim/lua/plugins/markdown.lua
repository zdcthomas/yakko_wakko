return {
	-- { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
	-- Your other plugins
	{
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		-- ** DEFAULT SETTINGS; TO USE THESE, PASS NO ARGUMENTS TO THE SETUP FUNCTION **
		opts = {
			modules = {
				bib = true,
				buffers = true,
				conceal = true,
				cursor = true,
				folds = true,
				foldtext = true,
				links = true,
				lists = true,
				maps = true,
				paths = true,
				tables = true,
				yaml = false,
				cmp = false,
			},
			-- SAMPLE FOLDTEXT CONFIGURATION RECIPE WITH COMMENTS
			-- Other config options
			foldtext = {
				object_count_icon_set = "nerdfont", -- Use/fall back on the nerdfont icon set
				-- object_count_opts = function()
				-- 	local opts = {
				-- 		link = true,
				-- 		blockquote = { -- Count block quotes (these aren't counted by default)
				-- 			icon = " ",
				-- 			count_method = {
				-- 				pattern = { "^>.+$" },
				-- 				tally = "blocks",
				-- 			},
				-- 		},
				-- 		fncblk = {
				-- 			-- Override the icon for fenced code blocks with 
				-- 			icon = " ",
				-- 		},
				-- 	}
				-- 	return opts
				-- end,
				line_count = true, -- Prevent lines from being counted
				word_count = true, -- Count the words in the section
				fill_chars = {
					left_edge = "╾─",
					right_edge = "──╼",
					item_separator = " · ",
					section_separator = " // ",
					left_inside = " ┝",
					right_inside = "┥ ",
					middle = "─",
				},
			},
			-- Other config options
			filetypes = { md = true, rmd = true, markdown = true },
			create_dirs = true,
			perspective = {
				priority = "first",
				fallback = "current",
				root_tell = false,
				nvim_wd_heel = false,
				update = false,
			},
			wrap = false,
			bib = {
				default_path = nil,
				find_in_root = true,
			},
			silent = false,
			cursor = {
				jump_patterns = nil,
			},
			links = {
				style = "markdown",
				name_is_source = false,
				conceal = false,
				context = 0,
				implicit_extension = nil,
				-- transform_implicit = false,
				transform_explicit = function(text)
					text = text:gsub(" ", "-")
					text = text:lower()
					return text
				end,
				create_on_follow_failure = true,
			},
			new_file_template = {
				use_template = true,
				placeholders = {
					before = {
						title = "link_title",
						date = "os_date",
					},
					after = {},
				},
				template = [[
---
title: {{title}}
date: {{date}}
---
          ]],
			},
			to_do = {
				symbols = { " ", "-", "X" },
				update_parents = true,
				not_started = " ",
				in_progress = "-",
				complete = "X",
			},
			tables = {
				trim_whitespace = true,
				format_on_move = true,
				auto_extend_rows = false,
				auto_extend_cols = false,
				style = {
					cell_padding = 1,
					separator_padding = 1,
					outer_pipes = true,
					mimic_alignment = true,
				},
			},
			yaml = {
				bib = { override = false },
			},
			mappings = {
				MkdnEnter = { { "n", "v" }, "<CR>" },
				MkdnTab = false,
				MkdnSTab = false,
				MkdnNextLink = { "n", "<Tab>" },
				MkdnPrevLink = { "n", "<S-Tab>" },
				MkdnNextHeading = { "n", "]]" },
				MkdnPrevHeading = { "n", "[[" },
				MkdnGoBack = { "n", "<BS>" },
				MkdnGoForward = false,
				MkdnCreateLink = false, -- see MkdnEnter
				MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>wp" }, -- see MkdnEnter
				MkdnFollowLink = false, -- see MkdnEnter
				MkdnDestroyLink = { "n", "<M-CR>" },
				MkdnTagSpan = { "v", "<M-CR>" },
				MkdnMoveSource = { "n", "<F2>" },
				MkdnYankAnchorLink = { "n", "yaa" },
				MkdnYankFileAnchorLink = false,
				MkdnIncreaseHeading = false,
				MkdnDecreaseHeading = false,
				MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
				MkdnNewListItem = false,
				MkdnNewListItemBelowInsert = { "n", "o" },
				MkdnNewListItemAboveInsert = { "n", "O" },
				MkdnExtendList = false,
				MkdnUpdateNumbering = { "n", "<leader>nn" },
				MkdnTableNextCell = { "i", "<Tab>" },
				MkdnTablePrevCell = { "i", "<S-Tab>" },
				MkdnTableNextRow = false,
				MkdnTablePrevRow = { "i", "<M-CR>" },
				MkdnTableNewRowBelow = { "n", "<leader>ir" },
				MkdnTableNewRowAbove = { "n", "<leader>iR" },
				MkdnTableNewColAfter = { "n", "<leader>ic" },
				MkdnTableNewColBefore = { "n", "<leader>iC" },
				MkdnFoldSection = { "n", "<leader>za" },
				MkdnUnfoldSection = { "n", "<leader>zd" },
			},
		},
	},
	-- {
	-- 	"serenevoid/kiwi.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	ft = { "markdown" },
	-- 	opts = {
	-- 		{
	-- 			name = "writing",
	-- 			path = vim.fn.expand("~/Irulan/wiki/writing"),
	-- 		},
	-- 	},
	-- 	keys = {
	-- 		{
	-- 			"<leader>ww",
	-- 			':lua require("kiwi").open_wiki_index("writing")<cr>',
	-- 			desc = "Open index of personal wiki",
	-- 		},
	-- 		{ "<leader>wt", ':lua require("kiwi").todo.toggle()<cr>', desc = "Toggle Markdown Task" },
	-- 	},
	-- },
	-- {
	-- 	"jghauser/follow-md-links.nvim",
	-- 	ft = {
	-- 		"markdown",
	-- 	},
	-- },

	{
		"richardbizik/nvim-toc",
		ft = {
			"markdown",
		},
		opts = {
			toc_header = "Table of Contents",
		},
	},
	{
		"toppair/peek.nvim",
		build = "deno task --quiet build:fast",
		ft = { "markdown" },
		cmd = {
			"PeekOpen",
			"PeekClosed",
		},
		config = function()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
			-- default config:
			require("peek").setup({
				auto_load = true, -- whether to automatically load preview when
				-- entering another markdown buffer
				close_on_bdelete = true, -- close preview window on buffer delete

				syntax = true, -- enable syntax highlighting, affects performance

				theme = "dark", -- 'dark' or 'light'

				update_on_change = true,

				app = "webview", -- 'webview', 'browser', string or a table of strings
				-- explained below

				filetype = { "markdown" }, -- list of filetypes to recognize as markdown

				-- relevant if update_on_change is true
				throttle_at = 200000, -- start throttling when file exceeds this
				-- amount of bytes in size
				throttle_time = "auto", -- minimum amount of time in milliseconds
				-- that has to pass before starting new render
			})
		end,
	},
}
