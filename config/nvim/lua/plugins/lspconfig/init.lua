local function setup_tsserver(capabilities, common_on_attach)
	require("lspconfig")["tsserver"].setup({
		on_attach = function(client, bufnr)
			-- client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	})
end

local function setup_rust(capabilities, common_on_attach)
	require("rust-tools").setup({
		tools = {
			autoSetHints = false,
			inlay_hints = {
				auto = false,
			},
			hover_actions = {
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},
				auto_focus = false,
			},
			runnables = {
				use_telescope = true,
			},
			dap = {
				adapter = {
					type = "executable",
					command = "lldb-vscode",
					name = "rt_lldb",
				},
			},
		},
		server = {
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					procMacro = {
						enable = true,
					},
					checkOnSave = {
						command = "clippy",
					},
					diagnostics = {
						experimental = { enable = true },
					},
					files = {
						excludeDirs = { "./relay-ui" },
					},
				},
			},
			on_attach = function(client, bufnr)
				common_on_attach(client, bufnr)
				local rt = require("rust-tools")
				vim.keymap.set("n", "gh", rt.hover_actions.hover_actions, { buffer = bufnr })
				vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
			end,
		},
	})
end

local function setup_eslint(capabilities, common_on_attach)
	require("lspconfig")["eslint"].setup({
		on_attach = function(client, bufnr)
			-- client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
		handlers = {
			["eslint/probeFailed"] = function()
				vim.notify("ESLint probe failed.", vim.log.levels.WARN)
				return {}
			end,
			["eslint/noLibrary"] = function()
				vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
				return {}
			end,
		},
	})
end

local function setup_lua(capabilities, common_on_attach)
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	require("neodev").setup({
		override = function(root_dir, library)
			if require("neodev.util").has_file(root_dir, "/etc/nixos") then
				library.enabled = true
				library.plugins = true
			end
		end,
	})

	-- then setup your lsp server as usual
	local lspconfig = require("lspconfig")

	-- example to setup sumneko and enable call snippets
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = runtime_path,
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
					-- Get the language server to recognize the `vim` and `hs` (hammerspoon) global
					globals = { "vim", "hs" },
				},
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	})
end

local function setup_lspconfig()
	require("fidget").setup({})
	-- local servers = {
	-- 	"rust_analyzer",
	-- 	"jsonls",
	-- 	"yamlls",
	-- 	"prosemd_lsp",
	-- 	"marksman",
	-- 	"rnix",
	-- 	"bashls",
	-- 	"elixirls",
	-- 	"lua_ls",
	-- 	"tsserver",
	-- 	"eslint",
	--  "sql_formatter",
	-- }

	require("mason-lspconfig").setup({
		-- ensure_installed = servers,
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded", close_events = { "CursorMoved", "BufHidden" } }
	)

	local common_on_attach = require("plugins.lspconfig.shared").common_on_attach
	local capabilities = require("plugins.lspconfig.shared").capabilities()

	if vim.fn.filereadable("/etc/NIXOS") == 1 then
		setup_lua(capabilities, common_on_attach)
		setup_rust(capabilities, common_on_attach)
		setup_eslint(capabilities, common_on_attach)
		setup_tsserver(capabilities, common_on_attach)
		local lspconfig = require("lspconfig")
		-- lspconfig.rnix.setup({
		-- 	on_attach = common_on_attach,
		-- 	capabilities = capabilities,
		-- })
		lspconfig.nixd.setup({
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				common_on_attach(client, bufnr)
			end,
			capabilities = capabilities,
		})

		lspconfig.marksman.setup({
			on_attach = common_on_attach,
			capabilities = capabilities,
		})
	else
		require("mason-lspconfig").setup_handlers({
			-- The first entry (without a key) will be the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler (optional)
				require("lspconfig")[server_name].setup({
					on_attach = common_on_attach,
					capabilities = capabilities,
				})
			end,
			["lua_ls"] = function()
				setup_lua(capabilities, common_on_attach)
			end,
			["tsserver"] = function()
				setup_tsserver(capabilities, common_on_attach)
			end,
			["eslint"] = function()
				setup_eslint(capabilities, common_on_attach)
			end,
			["rust_analyzer"] = function()
				setup_rust(capabilities, common_on_attach)
			end,
		})
	end
end

return {
	{
		"simrat39/symbols-outline.nvim",
		cmd = {
			"SymbolsOutlineClose",
			"SymbolsOutlineOpen",
			"SymbolsOutline",
		},
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUninstall", "MasonUninstallAll" },
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
			{ "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" },
			{ "j-hui/fidget.nvim", tag = "legacy" },
			-- "hrsh7th/nvim-cmp",
			"kosayoda/nvim-lightbulb",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "dodomorandi/rust-tools.nvim", dependencies = { "mfussenegger/nvim-dap" } },
			{
				"folke/neodev.nvim",
				ft = "lua",
			},
		},
		config = function()
			setup_lspconfig()
		end,
	},
}
