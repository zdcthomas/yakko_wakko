return {
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		-- enabled = true,
		dependencies = {

			"L3MON4D3/LuaSnip",
			-- 	version = "v2.*",
			-- },
			"saecki/crates.nvim",
			"rcarriga/cmp-dap",
			{
				"Kaiser-Yang/blink-cmp-git",
				dependencies = { "nvim-lua/plenary.nvim" },
			},

			{
				"saghen/blink.compat",
				-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
				version = "*",
				-- make sure to set opts so that lazy.nvim calls blink.compat's setup
				opts = {},
			},
			{
				"xzbdmw/colorful-menu.nvim",
				opts = {},
			},
		},
		event = "InsertEnter",

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
			enabled = function()
				return not vim.tbl_contains({ "org-roam-select" }, vim.bo.filetype)
					and vim.bo.buftype ~= "prompt"
					and vim.b.completion ~= false
			end,
			keymap = {
				preset = "default",

				-- -- show with a list of providers
				["<C-c>"] = { "cancel", "fallback" },
				["<C-space>"] = {
					function(cmp)
						cmp.show({ providers = { "snippets" } })
					end,
				},
				["<CR>"] = { "accept", "fallback" },
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
				["<Tab>"] = {
					-- TODO: <27-02-25, zdcthomas> do I like this?
					function(cmp)
						return cmp.select_next({ auto_insert = false })
					end,
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						return cmp.select_prev({ auto_insert = false })
					end,
					"fallback",
				},
			},

			cmdline = {
				completion = {
					list = {
						selection = {
							preselect = false,
						},
					},
					menu = { auto_show = true },
					-- ghost_text = { enabled = true },
				},
				keymap = {
					preset = "super-tab",
					["<Tab>"] = { "select_next", "fallback" },
					["<S-Tab>"] = { "select_prev", "fallback" },
				},
			},
			completion = {
				list = { selection = { preselect = false, auto_insert = true } },
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
				ghost_text = { enabled = true },
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
				per_filetype = {
					org = { "orgmode", "snippets", "path", "buffer" },
					["dap-repl"] = { "dap" },
					rust = { "crates", "lsp", "snippets", "path", "buffer" },
				},
				providers = {
					orgmode = {
						name = "Orgmode",
						module = "orgmode.org.autocompletion.blink",
						fallbacks = { "buffer" },
					},
					dap = { name = "dap", module = "blink.compat.source" },
					crates = {
						name = "crates",
						module = "blink.compat.source",
						opts = {},
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
