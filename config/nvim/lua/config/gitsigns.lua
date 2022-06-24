return function()
	require("gitsigns").setup({
		signs = {
			add = { hl = "GitSignsAdd", text = ">", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
			change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
			delete = { hl = "GitSignsDelete", text = "-", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
			topdelete = {
				hl = "GitSignsDelete",
				text = "‾",
				numhl = "GitSignsDeleteNr",
				linehl = "GitSignsDeleteLn",
			},
			changedelete = {
				hl = "GitSignsChange",
				text = "~",
				numhl = "GitSignsChangeNr",
				linehl = "GitSignsChangeLn",
			},
		},
		numhl = true,
		on_attach = function(bufnr)
			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			local gs = package.loaded.gitsigns
			local Hydra = Pquire("hydra")
			if Hydra then
				-- local hint = [[
            -- _n_: next hunk     _a_: stage hunk        _A_: stage buffer   _b_: blame line
            -- _p_: prev hunk     _U_: undo stage hunk   _P_: preview hunk   _B_: blame show full 
            -- _<Enter>_: Neogit  _q_: Set qf list       _/_: show base file _<Esc>_: leave
          -- ]]

				Hydra({
					-- hint = hint,
					config = {
						color = "pink",
						invoke_on_body = true,
						hint = {
							position = "bottom",
							border = "rounded",
						},
						on_exit = function()
							vim.cmd("echo") -- clear the echo area
						end,
					},
					mode = "n",
					body = "<leader><leader>g",
					heads = {
						{
							"n",
							function()
								if vim.wo.diff then
									return "]c"
								end
								vim.schedule(function()
									gs.next_hunk()
								end)
								return "<Ignore>"
							end,
							{ expr = true },
						},
						{
							"p",
							function()
								if vim.wo.diff then
									return "[c"
								end
								vim.schedule(function()
									gs.prev_hunk()
								end)
								return "<Ignore>"
							end,
							{ expr = true },
						},
						{ "a", ":Gitsigns stage_hunk<CR>", { silent = true } },
						{ "r", gs.undo_stage_hunk },
						{ "u", gs.reset_hunk },
						{
							"d",
							function()
								gs.diffthis("~")
							end,
						},
						{ "A", gs.stage_buffer },
						{ "s", gs.preview_hunk },
						{ "b", gs.blame_line },
						{
							"c",
							function()
								gs.setqflist("all")
							end,
							{ nowait = true },
						},
						-- {
						-- 	"B",
						-- 	function()
						-- 		gitsigns.blame_line({ full = true })
						-- 	end,
						-- },
						{ "/", gs.show, { exit = true } }, -- show the base of the file
						-- { "<Enter>", "<cmd>Neogit<CR>", { exit = true } },
						{ "<Esc>", nil, { exit = true, nowait = true } },
					},
				})
			end
			map({ "n", "v" }, "<leader>ga", ":Gitsigns stage_hunk<cr>", { desc = "Stage hunk under cursor" })
			map("n", "<leader>gA", gs.stage_buffer, { desc = "Stage entire buffer" })

			map("n", "<leader>gr", gs.undo_stage_hunk, { desc = "Undo changes to a hunk" })
			map({ "n", "v" }, "<leader>gu", ":Gitsigns reset_hunk<cr>", { desc = "Undo the staging of a hunk" })
			map("n", "<leader>gU", gs.reset_buffer, { desc = "Undo the staging of buffer" })

			map("n", "<leader>gn", gs.next_hunk, { desc = "Next hunkk" })
			map("n", "<leader>gp", gs.prev_hunk, { desc = "Previous hunk" })

			map("n", "<leader>gs", gs.preview_hunk, { desc = "Show hunk diff" })

			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, { desc = "Show full git blame" })

			map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "show git blame line" })

			map("n", "<leader>gd", function()
				gs.diffthis("~")
			end, { desc = "Show side by side git diff" })

			map("n", "<leader>gtd", gs.toggle_deleted, { desc = "show deleted" })

			map("n", "<leader>gc", function()
				gs.setqflist("all")
			end, { desc = "Send changes to quickfix list" })

			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "expand visual selection to hunk" })
		end,
	})
end
