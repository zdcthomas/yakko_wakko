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
		require("plugins.lspconfig.lua_ls").setup(capabilities, common_on_attach)
		require("plugins.lspconfig.rust_tools").setup(capabilities, common_on_attach)
		require("plugins.lspconfig.eslint").setup(capabilities, common_on_attach)
		require("plugins.lspconfig.tsserver").setup(capabilities, common_on_attach)

		local lspconfig = require("lspconfig")
		lspconfig.solargraph.setup({
			on_attach = common_on_attach,
			capabilities = capabilities,
		})
		lspconfig.nixd.setup({
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
				require("plugins.lspconfig.lua_ls").setup(capabilities, common_on_attach)
			end,
			["tsserver"] = function()
				require("plugins.lspconfig.tsserver").setup(capabilities, common_on_attach)
			end,
			["eslint"] = function()
				require("plugins.lspconfig.eslint").setup(capabilities, common_on_attach)
			end,
			["rust_analyzer"] = function()
				require("plugins.lspconfig.rust_tools").setup(capabilities, common_on_attach)
			end,
		})
	end
end

return {
	-- {
	-- 	"simrat39/symbols-outline.nvim",
	-- 	cmd = {
	-- 		"SymbolsOutlineClose",
	-- 		"SymbolsOutlineOpen",
	-- 		"SymbolsOutline",
	-- 	},
	-- 	config = function()
	-- 		require("symbols-outline").setup()
	-- 	end,
	-- },
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
			{
				"SmiteshP/nvim-navic",
				requires = "neovim/nvim-lspconfig",
			},
			{ "weilbith/nvim-code-action-menu", cmd = "CodeActionMenu" },
			{ "j-hui/fidget.nvim", opts = { window = { blend = 0 } } },
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
					enable = true, -- Will generate colors for the plugin based on your current colorscheme
					mode = "brighten", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
				},
				list = {
					position = "left", -- Position of the list window 'left'|'right'
					width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
				},
				detached = true,
				folds = {
					fold_closed = "󰅂", -- 󰅂 
					fold_open = "󰅀", -- 󰅀 
					folded = true,
				},
				border = {
					enable = true, -- Show window borders. Only horizontal borders allowed
					top_char = "―",
					bottom_char = "―",
				},
				hooks = {
					---@diagnostic disable-next-line: unused-local
					before_open = function(results, open, jump, method)
						local uri = vim.uri_from_bufnr(0)
						if #results == 1 then
							local target_uri = results[1].uri or results[1].targetUri

							if target_uri == uri then
								jump(results[1])
							else
								open(results)
							end
						else
							open(results)
						end
					end,
				},
				mappings = {
					list = {
						["<C-u>"] = actions.preview_scroll_win(5),
						["<C-d>"] = actions.preview_scroll_win(-5),
						["sg"] = actions.jump_vsplit,
						["sv"] = actions.jump_split,
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
