local conf = {}

function conf.lightbulb()
	require("nvim-lightbulb").update_lightbulb({
		sign = {
			enabled = true,
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


function conf.setup()
	vim.diagnostic.config({ header = false, float = { border = "rounded" }, signs = false })

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
    automatic_installation = true
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

	-- for _, server in ipairs(servers) do
	-- 	local config = make_config()
	-- 	config.capabilities = vim.tbl_extend("keep", config.capabilities, lsp_status.capabilities)

	-- 	if server == "sumneko_lua" then
	-- 		local lua_dev = pcall(require, "lua-dev")
	-- 		if lua_dev then
	-- 			config = lua(require("lua-dev").setup({ lspconfig = config }))
	-- 		else
	-- 			config = lua(config)
	-- 		end

	-- 		config = lua(require("lua-dev").setup({ lspconfig = config }))
	-- 	elseif server == "typescript" then
	-- 		config.on_attach = typescript_on_attach
	-- 	elseif server == "elixirls" then
	-- 		config = elixir(config)
	-- 	elseif server == "eslint" then
	-- 		config = eslint(config)
	-- 	end

	-- 	require("lspconfig")[server].setup(config)
	-- end

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
		underline = true,
		update_in_insert = false,
		virtual_text = true,
	})
end

return conf
