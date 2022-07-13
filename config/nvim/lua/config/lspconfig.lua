local conf = {}

local lspconfig_augroup = vim.api.nvim_create_augroup("LspConfigAuGroup", { clear = false })
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

capabilities.textDocument.codeAction = {
	dynamicRegistration = true,
	codeActionLiteralSupport = {
		codeActionKind = {
			valueSet = (function()
				local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
				table.sort(res)
				return res
			end)(),
		},
	},
}

capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
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

local common_on_attach = function(client, bufnr)
	vim.api.nvim_clear_autocmds({ buffer = bufnr, group = lspconfig_augroup })
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded" }
	)
	vim.api.nvim_create_autocmd(
		{ "CursorHold", "CursorHoldI" },
		{ callback = require("config.lspconfig").lightbulb, buffer = bufnr, group = lspconfig_augroup }
	)

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	local opts = { silent = false, buffer = bufnr }

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
	require("config.telescope").lsp_bindings_for_buffer(bufnr)

	if client.resolved_capabilities.hover then
		vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
	end

	if client.resolved_capabilities.rename then
		vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
	end

	if client.resolved_capabilities.code_lens then
		vim.keymap.set("n", "<Leader>cl", vim.lsp.codelens.run, opts)
		vim.api.nvim_create_autocmd(
			{ "BufEnter", "CursorHold", "InsertLeave" },
			{ buffer = bufnr, callback = vim.lsp.codelens.refresh, group = lspconfig_augroup }
		)
	end

	if client.resolved_capabilities.document_formatting then
		vim.keymap.set("n", "<leader>gq", vim.lsp.buf.formatting, opts)
		vim.api.nvim_create_autocmd(
			{ "BufWritePre" },
			{ buffer = bufnr, callback = vim.lsp.buf.formatting_sync, group = lspconfig_augroup }
		)
	end

	require("lsp_signature").on_attach({
		bind = true,
		zindex = 40,
		transparency = 40,
		auto_close_after = 4,
		max_width = 60,
		handler_opts = {
			border = "rounded", -- double, rounded, single, shadow, none
		},
	})
end

local function make_config()
	return {
		on_attach = common_on_attach,
		capabilities = capabilities,
	}
end

local function typescript_on_attach(client, bufnr)
	client.resolved_capabilities.document_formatting = false
	common_on_attach(client, bufnr)
end

local function eslint(config)
	config.on_attach = function(client, bufnr)
		print("attached")
		client.resolved_capabilities.document_formatting = true
		common_on_attach(client, bufnr)
	end
	config.settings = {
		format = { enable = true }, -- this will enable formatting
	}
	config.handlers = {
		["eslint/probeFailed"] = function()
			vim.notify("ESLint probe failed.", vim.log.levels.WARN)
			--return { id = nil, result = true }
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
			-- return { id = nil, result = true }
		end,
	}
	config.cmd = vim.list_extend({ "yarn", "node" }, config.cmd)
	return config
end

local function elixir(_)
	return {
		on_attach = common_on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
		root_dir = require("lspconfig.util").root_pattern(".git"),
		on_init = function(client)
			client.notify("workspace/didChangeConfiguration")
			return true
		end,
	}
end

local function lua(config)
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	return {
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			client.resolved_capabilities.document_formatting = false

			common_on_attach(client, bufnr)
			-- Stylua has been fucking up hard
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	buffer = bufnr,
			-- 	group = lspconfig_augroup,
			-- 	callback = function()
			-- 		require("stylua-nvim").format_file({ error_display_strategy = "none" })
			-- 	end,
			-- })
		end,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
		settings = {
			Lua = {
				format = {
					enable = false,
				},
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	}
end

function conf.setup()
	vim.diagnostic.config({ header = false, float = { border = "rounded" }, signs = false })

	local lsp_status = require("lsp-status")
	lsp_status.register_progress()

	local servers = {
		"sumneko_lua",
		"rust_analyzer",
		"elixirls",
		"jsonls",
		"tsserver",
		"yamlls",
		"prosemd_lsp",
		"marksman",
	}

	require("nvim-lsp-installer").setup({
		ensure_installed = servers,
	})

	for _, server in ipairs(servers) do
		local config = make_config()
		config.capabilities = vim.tbl_extend("keep", config.capabilities, lsp_status.capabilities)

		if server == "sumneko_lua" then
			local lua_dev = pcall(require, "lua-dev")
			if lua_dev then
				config = lua(require("lua-dev").setup({ lspconfig = config }))
			else
				config = lua(config)
			end

			config = lua(require("lua-dev").setup({ lspconfig = config }))
		elseif server == "typescript" then
			config.on_attach = typescript_on_attach
		elseif server == "elixirls" then
			config = elixir(config)
		elseif server == "eslint" then
			config = eslint(config)
		end

		require("lspconfig")[server].setup(config)
	end

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
		underline = true,
		update_in_insert = false,
		virtual_text = true,
	})
end

return conf
