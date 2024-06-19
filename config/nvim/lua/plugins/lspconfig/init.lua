local function setup_lspconfig()
	require("fidget").setup()

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded", close_events = { "CursorMoved", "BufHidden" } }
	)

	local common_on_attach = require("plugins.lspconfig.shared").common_on_attach
	local capabilities = require("plugins.lspconfig.shared").capabilities()

	require("plugins.lspconfig.lua_ls").setup(capabilities, common_on_attach)
	require("plugins.lspconfig.rust_tools").setup(capabilities, common_on_attach)
	require("plugins.lspconfig.eslint").setup(capabilities, common_on_attach)
	require("plugins.lspconfig.tsserver").setup(capabilities, common_on_attach)

	local lspconfig = require("lspconfig")
	lspconfig.solargraph.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})
	lspconfig.nushell.setup({
		on_attach = function(client, bufnr)
			-- client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	})
	lspconfig.nil_ls.setup({
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			common_on_attach(client, bufnr)
		end,
		capabilities = capabilities,
	})
	lspconfig.gdscript.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})

	lspconfig.ocamllsp.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})

	lspconfig.marksman.setup({
		on_attach = common_on_attach,
		capabilities = capabilities,
	})
end

return {
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
			{
				"SmiteshP/nvim-navic",
				dependencies = { "neovim/nvim-lspconfig" },
			},
			"j-hui/fidget.nvim",
			"kosayoda/nvim-lightbulb",
			{ "dodomorandi/rust-tools.nvim", dependencies = { "mfussenegger/nvim-dap" } },
		},
		config = setup_lspconfig,
	},
	{
		"dnlhc/glance.nvim",
		cmd = "Glance",
		keys = {
			{ "gpd", "<cmd>Glance definitions<CR>" },
			{ "gpr", "<cmd>Glance references<CR>" },
			{ "gpt", "<cmd>Glance type_definitions<CR>" },
			{ "gpi", "<cmd>Glance implementations<CR>" },
		},
		opts = function()
			local actions = require("glance").actions
			return {
				theme = { -- This feature might not work properly in nvim-0.7.2
					-- enable = true, -- Will generate colors for the plugin based on your current colorscheme
					-- mode = "brighten", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
				},
				list = {
					position = "left", -- Position of the list window 'left'|'right'
					width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
				},
				detached = function(winid)
					return vim.api.nvim_win_get_width(winid) < 100
				end,
				folds = {
					fold_closed = "󰅂", -- 󰅂 
					fold_open = "󰅀", -- 󰅀 
					folded = false,
				},
				border = {
					enable = true, -- Show window borders. Only horizontal borders allowed
					top_char = "―",
					bottom_char = "―",
				},
				hooks = {
					---@diagnostic disable-next-line: unused-local
					-- before_open = function(results, open, jump, method)
					-- 	local uri = vim.uri_from_bufnr(0)
					-- 	if #results == 1 then
					-- 		local target_uri = results[1].uri or results[1].targetUri
					--
					-- 		if target_uri == uri then
					-- 			jump(results[1])
					-- 		else
					-- 			open(results)
					-- 		end
					-- 	else
					-- 		open(results)
					-- 	end
					-- end,
				},
				mappings = {
					list = {
						["<C-u>"] = actions.preview_scroll_win(5),
						["<C-d>"] = actions.preview_scroll_win(-5),
						["<C-l>"] = actions.jump_vsplit,
						["<C-j>"] = actions.jump_split,
						["st"] = actions.jump_tab,
						["p"] = actions.enter_win("preview"),
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
