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
	lspconfig.sumneko_lua.setup({
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
					-- Get the language server to recognize the `vim` global
					globals = { "vim", "hs" },
				},
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	})
end
return {
	"neovim/nvim-lspconfig",
	event = "BufReadPost",
	dependencies = {
		"weilbith/nvim-code-action-menu",
		"j-hui/fidget.nvim",
		"hrsh7th/nvim-cmp",
		"kosayoda/nvim-lightbulb",
		"nvim-telescope/telescope.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"simrat39/rust-tools.nvim",
		{
			"folke/neodev.nvim",
			ft = "lua",
		},
	},
	config = function()
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
		-- 	"sumneko_lua",
		-- 	"tsserver",
		-- 	"eslint",
		-- }

		require("mason-lspconfig").setup({
			-- ensure_installed = servers,
		})

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
			vim.lsp.handlers.signature_help,
			{ border = "rounded", close_events = { "CursorMoved", "BufHidden" } }
		)

		local common_on_attach = require("config.lspconfig.shared").common_on_attach
		local capabilities = require("config.lspconfig.shared").capabilities()
		local lspconfig = require("lspconfig")

		require("config.lspconfig.eslint").setup()
		require("config.lspconfig.typescript").setup()

		setup_lua(capabilities, common_on_attach)
		require("rust-tools").setup({
			inlay_hints = false,
			hover_actions = {
				border = "rounded",
			},
			server = {
				on_attach = common_on_attach,
			},
		})

		require("rust-tools").inlay_hints.disable()

		lspconfig["jsonls"].setup({
			on_attach = common_on_attach,
			capabilities = capabilities,
		})

		lspconfig["marksman"].setup({
			on_attach = common_on_attach,
			capabilities = capabilities,
		})

		lspconfig["yamlls"].setup({
			on_attach = common_on_attach,
			capabilities = capabilities,
		})

		lspconfig["gopls"].setup({
			on_attach = common_on_attach,
			capabilities = capabilities,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
		})

		lspconfig["rnix"].setup({
			on_attach = common_on_attach,
			capabilities = capabilities,
		})
	end,
}
