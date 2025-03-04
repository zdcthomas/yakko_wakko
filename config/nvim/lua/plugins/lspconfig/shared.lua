local Module = {}

Module.lspconfig_augroup = vim.api.nvim_create_augroup("LspConfigAuGroup", { clear = false })

function Module.setup_dap_keybindings(bufnr)
	vim.keymap.set("n", "<Leader>B", require("dap").toggle_breakpoint, { buffer = bufnr })
	vim.keymap.set("n", "<Leader>dr", require("dap").repl.open, { buffer = bufnr })
	vim.keymap.set("n", "<Leader>dc", require("dap").continue, { buffer = bufnr })
	vim.keymap.set("n", "<Leader>dl", require("dap").step_into, { buffer = bufnr })
	vim.keymap.set("n", "<Leader>dh", require("dap").step_out, { buffer = bufnr })
end

function Module.capabilities()
	local capabilities
	capabilities = require("blink.cmp").get_lsp_capabilities()
	-- capabilities = require("cmp_nvim_lsp").default_capabilities()
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
local function with_desc(opts, desc)
	return vim.tbl_extend("keep", opts, { desc = desc })
end

Module.common_on_attach = function(client, bufnr)
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

	local function buf_set_option(name, value)
		vim.api.nvim_set_option_value(name, value, { buf = bufnr })
	end

	local opts = { silent = false, buffer = bufnr }

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set({ "i", "s" }, "<c-l>", vim.lsp.buf.signature_help, with_desc(opts, "Show Signature"))
	vim.keymap.set("n", "gl", vim.lsp.buf.signature_help, with_desc(opts, "Show signature"))
	vim.keymap.set("n", "gr", "<cmd>Glance references<CR>", with_desc(opts, "References"))
	vim.keymap.set({ "x", "n" }, "<leader>ca", vim.lsp.buf.code_action, with_desc(opts, "Code action"))
	vim.keymap.set("n", "gd", "<cmd>Glance definitions<CR>", with_desc(opts, "Definitions"))
	vim.keymap.set("n", "gt", "<cmd>Glance type_definitions<CR>", with_desc(opts, "Type definitions"))
	vim.keymap.set("n", "gi", "<cmd>Glance implementations<CR>", with_desc(opts, "Go to implementations"))
	vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, with_desc(opts, "Lsp Rename"))

	if client.server_capabilities.inlayHintProvider then
		vim.keymap.set("n", "<Leader>li", function()
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end, with_desc(opts, "Toggle inlay hints"))
	end

	if client.server_capabilities.codeLensProvider then
		vim.keymap.set("n", "<Leader>ll", vim.lsp.codelens.run, with_desc(opts, "Run code lens"))
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.refresh({ bufnr = bufnr })
			end,
			group = Module.lspconfig_augroup,
		})
	end

	if client.server_capabilities.documentFormattingProvider then
		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, with_desc(opts, "Formatting"))
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
