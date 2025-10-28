local function setup_lspconfig()
	require("fidget").setup()

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded", close_events = { "CursorMoved", "BufHidden" } }
	)

	local common_on_attach = require("plugins.lspconfig.shared").common_on_attach
	local capabilities = require("plugins.lspconfig.shared").capabilities()

	-- Set global defaults for all LSP servers
	vim.lsp.config("*", {
		capabilities = capabilities,
		root_markers = { ".git" },
	})

	-- Define LSP configurations using the new format
	local lsps = {
		-- Lua Language Server with custom configuration
		{
			"lua_ls",
			{
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					common_on_attach(client, bufnr)
				end,
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					})
				end,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = vim.split(package.path, ";"),
						},
						workspace = {
							checkThirdParty = false,
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
						telemetry = {
							enable = false,
						},
						diagnostics = {
							globals = { "vim", "hs" },
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
		},
		-- TypeScript/JavaScript
		{
			"ts_ls",
			{
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
			},
		},
		-- Go
		{ "gopls", { on_attach = common_on_attach } },
		-- Ruby
		{ "solargraph", { on_attach = common_on_attach } },
		-- Nushell
		{
			"nushell",
			{
				on_attach = function(client, bufnr)
					common_on_attach(client, bufnr)
				end,
			},
		},
		-- Nix
		{
			"nil_ls",
			{
				on_attach = function(client, bufnr)
					common_on_attach(client, bufnr)
				end,
				settings = {
					["nil"] = {
						formatting = {
							command = { "nixfmt" },
						},
						nix = {
							flake = {
								autoArchive = false,
							},
						},
					},
				},
			},
		},
		-- GDScript
		{ "gdscript", { on_attach = common_on_attach } },
		-- Clojure
		{ "clojure_lsp", { on_attach = common_on_attach } },
		-- OCaml
		{ "ocamllsp", { on_attach = common_on_attach } },
		-- Markdown
		{ "marksman", { on_attach = common_on_attach } },
	}

	-- Configure and enable all LSP servers
	for _, lsp in ipairs(lsps) do
		local name, config = lsp[1], lsp[2]
		if config then
			vim.lsp.config(name, config)
		end
		vim.lsp.enable(name)
	end
end

return {
	{
		"mrcjkb/rustaceanvim",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = function()
				local extension_path = vim.fn.expand(vim.env.RUST_DAP)

				local codelldb_path = extension_path .. "adapter/codelldb"
				local liblldb_path = extension_path .. "lldb/lib/liblldb"
				local this_os = vim.loop.os_uname().sysname

				liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
				local cfg = require("rustaceanvim.config")
				local adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
				require("dap").adapters["codelldb"] = adapter
				-- vim.print(adapter)
				return {

					tools = {
						test_executor = "neotest",
						-- enable_clippy = false,
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
								cargo = {
									allFeatures = true,
									loadOutDirsFromCheck = true,
									buildScripts = {
										enable = true,
									},
								},
								trace = {
									server = "verbose",
								},
								procMacro = {
									enable = true,
								},
								-- checkOnSave = {
								-- 	-- command = "clippy",
								-- },
								-- diagnostics = {
								-- 	-- experimental = { enable = true },
								-- },
								files = {
									excludeDirs = {
										"./relay-ui",
										".devenv",
										".direnv",
										".git",
										".github",
										".gitlab",
										"bin",
										"node_modules",
										"target",
										"venv",
										".venv",
									},
								},
							},
						},
					},
					dap = {
						-- autoload_configurations = false,
						adapter = false,
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
