return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		init = function()
			vim.keymap.set("n", "-", function()
				require("oil").open()
			end, { desc = "Open file explorer" })
		end,
		config = function()
			require("oil").setup({
				columns = {
					"icon",
					-- "permissions",
					-- "size",
					-- "mtime",
				},
				use_default_keymaps = false,
				watch_for_changes = true,
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<M-j>"] = "actions.select_vsplit",
					["<M-h>"] = "actions.select_split",
					-- ["<C-h>"] = false,
					-- ["<C-l>"] = false,
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<M-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					-- ["`"] = "actions.cd",
					-- ["~"] = "actions.tcd",
					["g."] = "actions.toggle_hidden",
				},
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = true,
				},
			})
		end,
	},
}
