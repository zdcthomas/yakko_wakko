return {
	-- { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
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
	{
		"jakewvincent/mkdnflow.nvim",
		ft = "markdown",
		config = function()
			require("mkdnflow").setup({
				modules = {
					bib = true,
					buffers = true,
					conceal = true,
					cursor = true,
					folds = true,
					links = true,
					lists = true,
					maps = true,
					paths = true,
					tables = true,
					yaml = false,
				},
				filetypes = { md = true, markdown = true },
				create_dirs = true,
				perspective = {
					priority = "first",
					fallback = "current",
					root_tell = false,
					nvim_wd_heel = false,
					update = false,
				},
				wrap = true,
				bib = {
					default_path = nil,
					find_in_root = true,
				},
				silent = false,
				links = {
					style = "markdown",
					name_is_source = false,
					conceal = false,
					context = 0,
					implicit_extension = nil,
					transform_implicit = false,
					transform_explicit = function(text)
						text = text:gsub(" ", "-")
						text = text:lower()
						return text
					end,
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
				},
				yaml = {
					bib = { override = false },
				},
				mappings = {
					MkdnEnter = { { "i", "n", "v" }, "<CR>" },
					MkdnTab = false,
					MkdnSTab = false,
					MkdnNextLink = { "n", "<Tab>" },
					MkdnPrevLink = { "n", "<S-Tab>" },
					MkdnNextHeading = { "n", "]]" },
					MkdnPrevHeading = { "n", "[[" },
					MkdnGoBack = { "n", "<BS>" },
					MkdnGoForward = { "n", "<Del>" },
					MkdnCreateLink = false, -- see MkdnEnter
					MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>l" }, -- see MkdnEnter
					MkdnFollowLink = false, -- see MkdnEnter
					MkdnDestroyLink = { "n", "<M-CR>" },
					MkdnTagSpan = { "v", "<M-CR>" },
					MkdnMoveSource = { "n", "<F2>" },
					MkdnYankAnchorLink = { "n", "yaa" },
					MkdnYankFileAnchorLink = { "n", "yfa" },
					MkdnIncreaseHeading = { "n", "+" },
					MkdnDecreaseHeading = { "n", "=" },
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
					MkdnFoldSection = false,
					MkdnUnfoldSection = false,
				},
			})
		end,
	},
}
