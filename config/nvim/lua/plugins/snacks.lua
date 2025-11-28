return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = false },
			explorer = { enabled = false },
			indent = { enabled = false },
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = false },
			quickfile = { enabled = true },
			scope = { enabled = false },
			lazygit = {
				configure = true,
			},
			scroll = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = true },
		},
		init = function()
			vim.keymap.set("n", "<leader>gg", function()
				Snacks.lazygit()
			end, { desc = "Launch lazygit" })
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					-- Create some toggle mappings
				end,
			})
		end,
	},
}
