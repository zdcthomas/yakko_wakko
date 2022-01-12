local conf = {}

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

local border = {
	{ "🭽", "NormalFloat" },
	{ "▔", "NormalFloat" },
	{ "🭾", "NormalFloat" },
	{ "▕", "NormalFloat" },
	{ "🭿", "NormalFloat" },
	{ "▁", "NormalFloat" },
	{ "🭼", "NormalFloat" },
	{ "▏", "NormalFloat" },
}

capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
function conf.lightbulb()
	require("nvim-lightbulb").update_lightbulb({
		sign = {
			enabled = false,
		},
		float = {
			enabled = true,
			text = "💡",
		},
	})
end

local common_on_attach = function(client, bufnr)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
	vim.cmd("au! CursorHold,CursorHoldI <buffer> lua require('config.lspconfig').lightbulb()")
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local opts = { silent = false, noremap = true }

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	buf_set_keymap("n", "gh", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<Leader>cl", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)
	buf_set_keymap("n", "<Leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<Leader><Leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	require("config.telescope").lsp_bindings_for_buffer(bufnr)

	if client.resolved_capabilities.document_formatting then
		buf_set_keymap("n", "<Leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
		vim.cmd("au! BufWritePre <buffer> lua vim.lsp.buf.formatting()")
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

local function lua_settings()
	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	return {
		Lua = {
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
	}
end

local function make_config()
	return {
		on_attach = common_on_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		},
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

local function elixir(config)
	config.root_dir = require("lspconfig.util").root_pattern(".git")
	config.on_init = function(client)
		client.notify("workspace/didChangeConfiguration")
		return true
	end
	return config
end
local function lua(config)
	config.settings = lua_settings()
	config.commands = {
		Format = {
			function()
				require("stylua-nvim").format_file({
					error_display_strategy = "none",
				})
			end,
		},
	}
	config.on_attach = function(client, bufnr)
		common_on_attach(client, bufnr)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<Leader>gq",
			"<cmd>lua require('stylua-nvim').format_file()<CR>",
			{ silent = false, noremap = true }
		)
		vim.cmd("au! BufWritePre <buffer> Format")
	end
	return config
end

function conf.setup()
	vim.diagnostic.config({ header = false, float = { border = "rounded" }, signs = false })

	local lsp_status = require("lsp-status")
	lsp_status.register_progress()

	local lsp_installer = require("nvim-lsp-installer")

	lsp_installer.on_server_ready(function(server)
		local config = make_config()
		config.capabilities = vim.tbl_extend("keep", config.capabilities, lsp_status.capabilities)
		config.cmd = server._default_options.cmd
		if server.name == "sumneko_lua" then
			config = lua(config)
		elseif server.name == "typescript" then
			config.on_attach = typescript_on_attach
		elseif server.name == "elixirls" then
			config = elixir(config)
		elseif server.name == "eslint" then
			config = eslint(config)
		end

		server:setup(config)
	end)

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
		underline = true,
		update_in_insert = false,
		virtual_text = true,
	})
end

return conf
