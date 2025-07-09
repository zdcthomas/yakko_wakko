return {

	{
		"ruifm/gitlinker.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		keys = {
			"<leader>gy",
		},
		config = function()
			require("gitlinker").setup()
		end,
	},
	{ "https://github.com/tpope/vim-fugitive", cmd = { "Git" } },
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					local nav_hunk_opts = {
						greedy = false,
					}
					-- Navigation
					map("n", "<leader>gn", function()
						-- if vim.wo.diff then
						-- 	vim.cmd.normal({ "]c", bang = true })
						-- else
						gitsigns.nav_hunk("next", nav_hunk_opts)
						-- end
					end, { desc = "next hunk" })

					map("n", "<leader>gp", function()
						-- if vim.wo.diff then
						-- 	vim.cmd.normal({ "[c", bang = true })
						-- else
						gitsigns.nav_hunk("prev", nav_hunk_opts)
						-- end
					end, { desc = "previous hunk" })

					-- Actions
					map("n", "<leader>ga", gitsigns.stage_hunk, { desc = "stage hunk" })
					map("n", "<leader>gu", gitsigns.reset_hunk, { desc = "reset hunk" })
					map("v", "<leader>ga", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "stage hunk" })
					map("v", "<leader>gu", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "reset hunk" })
					map("n", "<leader>gA", gitsigns.stage_buffer, { desc = "stage buffer" })
					-- map("n", "<leader>gr", gitsigns.undo_stage_hunk)
					map("n", "<leader>gU", gitsigns.reset_buffer, { desc = "git reset buffer" })
					map("n", "<leader>gP", gitsigns.preview_hunk, { desc = "git preview hunk" })
					-- map("n", "<leader>gb", function()
					-- 	gitsigns.blame_line({ full = true })
					-- end)
					map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "toggle current line blame" })
					map("n", "<leader>gd", gitsigns.diffthis, { desc = "show diff of hunk" })
					map("n", "<leader>gD", function()
						gitsigns.diffthis("~")
					end, { desc = "show diff of file" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "git hunk text object" })
				end,
				signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
				numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				-- watch_gitdir = {
				-- 	follow_files = true,
				-- },
				auto_attach = true,
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				sign_priority = 6,
				-- update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},
}
