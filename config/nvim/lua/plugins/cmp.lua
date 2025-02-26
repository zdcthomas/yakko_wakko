-- If you start to lazy load cmp, this will break cause you're dumbcmp.lu
-- sincerely, Zach from 17-10-2021
--
-- Okay old(younger) Zach, how about this prequire?? huh?
-- Zach from 26-10-2021
--
-- You are like baby, watch this
-- Zach from 12-20-2022
--
-- Ok, I guess blink is a thing now, so I guess we're trying it out
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
			popup = {
				border = "rounded",
			},
			src = {
				cmp = {
					enabled = true,
				},
			},
		},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		enabled = true,
		dependencies = {
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			{
				"xzbdmw/colorful-menu.nvim",
				opts = {},
			},
		},

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- selection = {
			--   preselect = false,
			--   },
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = "default",

				-- -- show with a list of providers
				["<CR>"] = { "select_and_accept", "fallback" },
				["<C-p>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
				["<C-e>"] = { "hide" },
				["<C-j>"] = {
					"scroll_documentation_down",
					"fallback",
				},
				["<C-k>"] = {
					"scroll_documentation_up",
					"fallback",
				},
				["<Tab>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
			},

			cmdline = {
				-- menu = { auto_show = true },
				completion = {
					-- trigger = {
					-- 	show_on_blocked_trigger_characters = {},
					-- 	show_on_x_blocked_trigger_characters = {},
					-- },
					-- list = {
					-- 	selection = {
					-- 		-- When `true`, will automatically select the first item in the completion list
					-- 		preselect = true,
					-- 		-- When `true`, inserts the completion item automatically when selecting it
					-- 		auto_insert = true,
					-- 	},
					-- },
					-- Whether to automatically show the window when new completion items are available
					menu = { auto_show = true },
					-- Displays a preview of the selected item on the current line
					ghost_text = { enabled = true },
				},
				keymap = {
					preset = "super-tab",
					["<Tab>"] = { "select_next", "fallback" },

					-- sets <CR> to accept the item and run the command immediately
					-- use `select_accept_and_enter` to accept the item or the first item if none are selected
					-- ["<CR>"] = {},
					--
					-- [""] = { "select_prev", "snippet_backward", "fallback" },
					-- ["<C-n>"] = { "select_next", "snippet_forward", "fallback" },
				},
			},
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					draw = {
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},

					border = "rounded",
				},
				documentation = {

					auto_show = true,
					auto_show_delay_ms = 500,
					window = { border = "rounded" },
				},
			},
			snippets = { preset = "luasnip" },
			signature = {
				enabled = true,
				window = {
					show_documentation = false,
					border = "rounded",
				},
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
			},
		},
		opts_extend = { "sources.default" },
	},
}
