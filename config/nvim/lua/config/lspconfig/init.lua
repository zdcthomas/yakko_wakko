local conf = {}

function conf.lightbulb()
	require("nvim-lightbulb").update_lightbulb({
		sign = {
			enabled = false,
		},
		virtual_text = {
			enabled = true,
			-- Text to show at virtual text
			text = "💡",
			-- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
			hl_mode = "combine",
		},
	})
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", close_events = { "CursorMoved", "BufHidden" } })

function conf.setup()
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

	local common_on_attach = require("config.lspconfig.shared").common_on_attach
	local capabilities = require("config.lspconfig.shared").capabilities()
	local lspconfig = require("lspconfig")

	require("config.lspconfig.eslint").setup()
	require("config.lspconfig.typescript").setup()

	require("config.lspconfig.lua").setup()
	require("config.lspconfig.rust").setup()

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
end

return conf
