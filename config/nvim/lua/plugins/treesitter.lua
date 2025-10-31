return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "VeryLazy" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nushell/tree-sitter-nu",
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				config = function()
					require("ts_context_commentstring").setup({
						enable_autocmd = false,
					})
				end,
			},
		},
		opts = {
			textobjects = {
				lsp_interop = {
					enable = true,
					border = "none",
					floating_preview_opts = { border = "rounded" },
					peek_definition_code = {
						["<leader>df"] = "@function.outer",
						["<leader>dF"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["]a"] = "@parameter.inner",
					},
					swap_previous = {
						["[a"] = "@parameter.inner",
					},
				},
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = false,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["aa"] = { query = "@parameter.outer", desc = "around argument" },
						["ia"] = { query = "@parameter.inner", desc = "in argument" },
						["af"] = { query = "@function.outer", desc = "around function" },
						["if"] = { query = "@function.inner", desc = "in function" },
						["ac"] = { query = "@class.outer", desc = "around class" },
						["ic"] = { query = "@class.inner", desc = "in class" },
						["aS"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
					},
				},
			},
			indent = { enable = true },
			-- autopairs = { enable = true },
			auto_install = false,
			sync_install = false,
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
			refactor = {
				highlight_definitions = {
					enable = true,
					-- Set to false if you have an `updatetime` of ~100.
					clear_on_cursor_move = true,
				},
			},
			-- TODO: Figure out if this is slowing this down
			ensure_installed = {
				-- "bash",
				-- "comment",
				-- "dockerfile",
				-- "elixir",
				-- "fennel",
				-- "fish",
				-- "gleam",
				-- "go",
				-- "gomod",
				-- "graphql",
				-- "heex",
				-- "html",
				-- "http",
				-- "hurl",
				-- "javascript",
				-- "json",
				-- "lua",
				-- "make",
				-- "markdown",
				-- "markdown_inline",
				-- "nix",
				-- "python",
				-- "regex",
				-- "ruby",
				-- "rust",
				-- "toml",
				-- "tsx",
				-- "typescript",
				-- "vim",
				-- "vimdoc",
			},
			-- disable = {
			-- 	"vimdoc",
			-- },
			highlight = {
				enable = true,
			},
		},
		config = function(_, opts)
			-- require("nvim-treesitter").setup(opts)
			-- vim.print(opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/playground",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		cmd = "TSPlaygroundToggle",
	},
}
