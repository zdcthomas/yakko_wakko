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

vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
	vim.notify({ result.message }, lvl, {
		title = "LSP | " .. client.name,
		timeout = 10000,
		keep = function()
			return lvl == "ERROR" or lvl == "WARN"
		end,
	})
end
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

function conf.setup()
	local lsp_status = require("lsp-status")
	lsp_status.register_progress()

	local default_config_servers = {
		"rust_analyzer",
		"jsonls",
		"yamlls",
		"prosemd_lsp",
		"marksman",
	}

	require("nvim-lsp-installer").setup({
		automatic_installation = true,
	})
	require("config.lspconfig.elixir").setup()
	require("config.lspconfig.lua").setup()
	require("config.lspconfig.elixir").setup()
	require("config.lspconfig.typescript").setup()

	local common_on_attach = require("config.lspconfig.shared").common_on_attach
	local capabilities = require("config.lspconfig.shared").capabilities()

	for _, server in ipairs(default_config_servers) do
		require("lspconfig")[server].setup({
			on_attach = common_on_attach,
			capabilities = capabilities,
		})
	end

	-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	-- 	signs = true,
	-- 	underline = true,
	-- 	update_in_insert = false,
	-- 	virtual_text = true,
	-- })
end

return conf
