local function setup_lspconfig()
	require("fidget").setup()

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded", close_events = { "CursorMoved", "BufHidden" } }
	)

	local common_on_attach = require("plugins.lspconfig.shared").common_on_attach
	local capabilities = require("plugins.lspconfig.shared").capabilities()

	require("plugins.lspconfig.lua_ls").setup(capabilities, common_on_attach)

	local lspconfig = require("lspconfig")

	-- lspconfig.eslint.setup({
	-- 	on_attach = function(client, bufnr)
	-- 		-- client.server_capabilities.documentFormattingProvider = false
	-- 		common_on_attach(client, bufnr)
	-- 	end,
	-- 	capabilities = capabilities,
	-- 	settings = {
	-- 		format = false,
	-- 	},
	-- 	handlers = {
	-- 		["eslint/probeFailed"] = function()
	-- 			vim.notify("ESLint probe failed.", vim.log.levels.WARN)
	-- 			return {}
	-- 		end,
	-- 		["eslint/noLibrary"] = function()
	-- 			vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
	-- 			return {}
	-- 		end,
	-- 	},
	-- })
	lspconfig.ts_ls.setup({
		on_attach = common_on_attach,
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
				},
			},
		},
		capabilities = capabilities,
	})
	lspconfig.solargraph.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})
	lspconfig.nushell.setup({
		on_attach = function(client, bufnr)
			-- client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	})
	lspconfig.nil_ls.setup({
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	})
	lspconfig.gdscript.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})

	lspconfig.ocamllsp.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})

	lspconfig.marksman.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})
end

return {
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false,
		init = function()
			vim.g.rustaceanvim = function()
				local extension_path = vim.env.RUST_DAP

				local codelldb_path = extension_path .. "adapter/codelldb"
				local liblldb_path = extension_path .. "lldb/lib/liblldb"
				local this_os = vim.loop.os_uname().sysname

				liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
				local cfg = require("rustaceanvim.config")
				return {

					tools = {
						float_win_config = {
							border = "rounded",
						},
					},
					server = {
						on_attach = function(client, bufnr)
							require("plugins.lspconfig.shared").common_on_attach(client, bufnr)

							local opts = { silent = false, buffer = bufnr }
							vim.keymap.set("n", "gH", function()
								vim.cmd.RustLsp("openDocs")
							end, opts)

							vim.keymap.set({ "n", "x" }, "J", function()
								vim.cmd.RustLsp("joinLines")
							end, opts)

							vim.keymap.set({ "n", "x" }, "<leader>k", function()
								vim.cmd.RustLsp("moveItem", "up")
							end, opts)

							vim.keymap.set({ "n", "x" }, "<leader>j", function()
								vim.cmd.RustLsp("moveItem", "down")
							end, opts)

							vim.keymap.set({ "n", "x" }, "<leader>E", function()
								vim.cmd.RustLsp("explainError")
							end, opts)
						end,
						default_settings = {
							-- rust-analyzer language server configuration
							["rust-analyzer"] = {
								typing = {
									autoClosingAngleBrackets = {
										enable = true,
									},
								},
								trace = {
									server = "verbose",
								},
								-- procMacro = {
								-- 	enable = true,
								-- },
								-- checkOnSave = {
								-- 	-- command = "clippy",
								-- },
								-- diagnostics = {
								-- 	-- experimental = { enable = true },
								-- },
								files = {
									excludeDirs = { "./relay-ui", ".direnv" },
								},
							},
						},
					},
					dap = {
						adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
					},
				}
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			"j-hui/fidget.nvim",
			"saghen/blink.cmp",
			"kosayoda/nvim-lightbulb",
		},
		config = setup_lspconfig,
	},
	{
		"dnlhc/glance.nvim",
		cmd = "Glance",
		opts = function()
			local actions = require("glance").actions
			return {
				theme = {
					enable = true,
					mode = "auto",
				},
				list = {
					position = "left", -- Position of the list window 'left'|'right'
					width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
				},
				detached = function(winid)
					return vim.api.nvim_win_get_width(winid) < 100
				end,
				folds = {
					folded = true,
				},
				winbar = {
					enable = true,
				},
				border = {
					enable = true, -- Show window borders. Only horizontal borders allowed
					-- top_char = "―",
					-- bottom_char = "―",
				},
				mappings = {
					list = {
						["<Tab>"] = actions.next_location,
						["<S-Tab>"] = actions.previous_location,
						["<C-u>"] = actions.preview_scroll_win(5),
						["<C-d>"] = actions.preview_scroll_win(-5),
						["<C-l>"] = actions.jump_vsplit,
						["<C-j>"] = actions.jump_split,
						["<C-q>"] = actions.quickfix,
						["st"] = actions.jump_tab,
						["p"] = actions.enter_win("preview"),
						["l"] = actions.open_fold,
						["h"] = actions.close_fold,
						["<Esc>"] = actions.close,
					},
					preview = {
						["q"] = actions.close,
						["p"] = actions.enter_win("list"),
					},
				},
			}
		end,
	},
}
