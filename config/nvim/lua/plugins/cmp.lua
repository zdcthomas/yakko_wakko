-- If you start to lazy load cmp, this will break cause you're dumbcmp.lu
-- sincerely, Zach from 17-10-2021
--
-- Okay old(younger) Zach, how about this prequire?? huh?
-- Zach from 26-10-2021
--
-- You are like baby, watch this
-- Zach from 12-20-2022
--
-- Ok, I guess blink is a thing now, so I guess we're trying it out over in ./blink.lua
-- Zach from 24-2-2025

local function snippet_func(args)
	require("luasnip").lsp_expand(args.body)
end

local replace_termcodes = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(replace_termcodes(key), mode, true)
end

return {
	{
		"saecki/crates.nvim",
		version = false,
		event = { "BufRead Cargo.toml" },
		dependencies = { "nvim-lua/plenary.nvim" },
		init = function()
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function(ev)
					---@diagnostic disable-next-line: missing-fields
					local crates = require("crates")
					local opts = { silent = true, buffer = ev.buf }

					vim.keymap.set(
						"n",
						"<leader>cl",
						crates.toggle,
						vim.tbl_extend("keep", opts, { desc = "[c]rate togg[l]e" })
					)
					vim.keymap.set(
						"n",
						"<leader>cr",
						crates.reload,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [r]eload" })
					)

					vim.keymap.set(
						"n",
						"<leader>cv",
						crates.show_versions_popup,
						vim.tbl_extend("keep", opts, { desc = "[c]rate show [v]ersions" })
					)
					vim.keymap.set(
						"n",
						"<leader>cf",
						crates.show_features_popup,
						vim.tbl_extend("keep", opts, { desc = "[c]rate show [f]eatures" })
					)
					vim.keymap.set(
						"n",
						"<leader>cd",
						crates.show_dependencies_popup,
						vim.tbl_extend("keep", opts, { desc = "[c]rate show [d]ependencies" })
					)

					vim.keymap.set(
						"n",
						"<leader>cu",
						crates.update_crate,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [u]pdate" })
					)
					vim.keymap.set(
						"v",
						"<leader>cu",
						crates.update_crates,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [u]pdate" })
					)
					vim.keymap.set(
						"n",
						"<leader>ca",
						crates.update_all_crates,
						vim.tbl_extend("keep", opts, { desc = "[c]rate update [a]ll" })
					)
					vim.keymap.set(
						"n",
						"<leader>cU",
						crates.upgrade_crate,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [U]pgrade" })
					)
					vim.keymap.set(
						"v",
						"<leader>cU",
						crates.upgrade_crates,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [U]pgrade" })
					)
					vim.keymap.set(
						"n",
						"<leader>cA",
						crates.upgrade_all_crates,
						vim.tbl_extend("keep", opts, { desc = "[c]rate upgrade [a]ll" })
					)

					vim.keymap.set(
						"n",
						"<leader>ce",
						crates.expand_plain_crate_to_inline_table,
						vim.tbl_extend("keep", opts, { desc = "[c]rate [e]xpand" })
					)
					vim.keymap.set(
						"n",
						"<leader>ct",
						crates.extract_crate_into_table,
						vim.tbl_extend("keep", opts, { desc = "extract [c]rate into [t]able" })
					)

					vim.keymap.set(
						"n",
						"<leader>ch",
						crates.open_homepage,
						vim.tbl_extend("keep", opts, { desc = "show [c]rate [Homepage]" })
					)
					vim.keymap.set(
						"n",
						"<leader>cR",
						crates.open_repository,
						vim.tbl_extend("keep", opts, { desc = "open [c]rate [R]epository" })
					)
					vim.keymap.set(
						"n",
						"<leader>cD",
						crates.open_documentation,
						vim.tbl_extend("keep", opts, { desc = "open [c]rate [D]ocumentation" })
					)
					vim.keymap.set(
						"n",
						"<leader>cC",
						crates.open_crates_io,
						vim.tbl_extend("keep", opts, { desc = "show [c]rate on [C]rates.io" })
					)

					vim.keymap.set("n", "gh", crates.show_popup, opts)
				end,
			})
		end,
		opts = {
			completion = {
				crates = {
					enabled = true,
				},
			},
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
			popup = {
				border = "rounded",
			},
		},
	},
}
