local Module = {}

local function window_splittable(mode, map, func, opts)
	vim.keymap.set(mode, map, function()
		local key = vim.fn.getcharstr()
		local cmd = {
			j = ":rightbelow sp",
			l = ":rightbelow vsp",
			k = ":leftabove sp",
			h = ":leftabove vsp",
			t = "",
		}
		if cmd[key] == nil then
			return
		end
		vim.cmd(cmd[key])

		func()
	end, opts)
end

Module.lspconfig_augroup = vim.api.nvim_create_augroup("LspConfigAuGroup", { clear = false })

function Module.setup_dap_keybindings(bufnr)
	vim.keymap.set("n", "<Leader>B", require("dap").toggle_breakpoint, { buffer = bufnr })
	vim.keymap.set("n", "<Leader>dr", require("dap").repl.open, { buffer = bufnr })
	vim.keymap.set("n", "<Leader>dc", require("dap").continue, { buffer = bufnr })
	vim.keymap.set("n", "<Leader>dl", require("dap").step_into, { buffer = bufnr })
	vim.keymap.set("n", "<Leader>dh", require("dap").step_out, { buffer = bufnr })
end

function Module.capabilities()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
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

	-- capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	local ok, lsp_status = pcall(require, "lsp-status")
	if ok then
		capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities) or capabilities
	end
	return capabilities
end

Module.common_on_attach = function(client, bufnr)
	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end
	vim.api.nvim_clear_autocmds({ buffer = bufnr, group = Module.lspconfig_augroup })

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		callback = function()
			require("nvim-lightbulb").update_lightbulb({
				sign = {
					enabled = false,
				},
				virtual_text = {
					enabled = true,
					-- Text to show at virtual text
					text = "",
					-- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
					hl_mode = "combine",
				},
			})
		end,
		buffer = bufnr,
		group = Module.lspconfig_augroup,
	})

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	local opts = { silent = false, buffer = bufnr }

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set({ "i", "s" }, "<c-l>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "gl", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "gr", "<cmd>Glance references<CR>", opts)
	vim.keymap.set({ "x", "n" }, "<Leader>ca", "<cmd>CodeActionMenu<cr>", opts)
	vim.keymap.set("i", "<c-a>", "<cmd>CodeActionMenu<cr>", opts)
	vim.keymap.set("n", "gd", "<cmd>Glance definitions<CR>", opts)
	vim.keymap.set("n", "gt", "<cmd>Glance type_definitions<CR>", opts)
	vim.keymap.set("n", "gi", "<cmd>Glance implementations<CR>", opts)
	vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)

	if client.server_capabilities.codeLensProvider then
		vim.keymap.set("n", "<Leader>cl", vim.lsp.codelens.run, opts)
		vim.api.nvim_create_autocmd(
			{ "BufEnter", "CursorHold", "InsertLeave" },
			{ buffer = bufnr, callback = vim.lsp.codelens.refresh, group = Module.lspconfig_augroup }
		)
	end

	if client.server_capabilities.documentFormattingProvider then
		vim.keymap.set("n", "<leader>gq", vim.lsp.buf.format, opts)
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			buffer = bufnr,
			callback = function()
				if vim.g.format_on_save then
					vim.lsp.buf.format()
				end
			end,
			group = Module.lspconfig_augroup,
		})
	end
end

return Module
