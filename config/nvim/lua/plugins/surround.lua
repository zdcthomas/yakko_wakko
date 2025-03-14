return {
	{
		"kylechui/nvim-surround",
		keys = {
			{ "ys", mode = "n" },
			{ "yss", mode = "n" },
			{ "ds", mode = "n" },
			{ "cs", mode = "n" },
			{ "S", mode = "x" },
			{ "gS", mode = "x" },
			{ "<c-g>s", mode = "i" },
			{ "<c-g>S", mode = "i" },
		},
		init = function()
			local surround_group = vim.api.nvim_create_augroup("zdcthomasSurroundGroup", { clear = true })

			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = "org",
				callback = function()
					local get_input = require("nvim-surround.input").get_input
					require("nvim-surround").buffer_setup({
						surrounds = {
							["s"] = {
								add = function()
									local result = get_input("Enter the language name: ")
									if result then
										return { { "#+begin_src " .. result, "" }, { "", "#+end_src" } }
									end
								end,
							},
							["l"] = {
								add = function()
									return {
										{ "[[" },
										{ "]]" },
									}
								end,
							},
						},
					})
				end,
				desc = "setup surround for eliixr",
			})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = { "rust", "typescript", "typescriptreact" },
				callback = function()
					local get_input = require("nvim-surround.input").get_input
					require("nvim-surround").buffer_setup({
						surrounds = {
							["g"] = {
								add = function()
									local input = get_input("Enter the Generic: ")
									if input then
										return { { input .. "<" }, { ">" } }
									end
								end,
							},
						},
					})
				end,
				desc = "setup surround for eliixr",
			})
			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = "markdown",
				callback = function()
					require("nvim-surround").buffer_setup({
						surrounds = {
							["l"] = {
								add = function()
									return {
										{ "[" },
										{ "]( )" },
									}
								end,
								find = "%b[]%b()",
								delete = "^(%[)().-(%]%b())()$",
								-- change = {
								-- 	target = "^()()%b[]%((.-)()%)$",
								-- 	replacement = function()
								-- 		local clipboard = vim.fn.getreg("+"):gsub("\n", "")
								-- 		return {
								-- 			{ "" },
								-- 			{ clipboard },
								-- 		}
								-- 	end,
								-- },
							},
						},
					})
				end,
				desc = "setup surround for eliixr",
			})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
				callback = function()
					require("nvim-surround").buffer_setup({
						surrounds = {
							["F"] = {
								add = { "() => { ", " }" },
							},
						},
					})
				end,
				desc = "setup surround for eliixr",
			})
			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = { "lua" },
				callback = function()
					require("nvim-surround").buffer_setup({
						surrounds = {
							["F"] = {
								add = { "function () ", " end" },
							},
							["p"] = {
								add = { "vim.print(", ")" },
								find = "vim%.print%b()",
								delete = "^(vim%.print%()().-(%))()$",
								change = {
									target = "^(vim%.print%()().-(%))()$",
								},
							},
						},
					})
				end,
				desc = "setup surround for lua",
			})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = surround_group,
				pattern = { "elixir" },
				callback = function()
					require("nvim-surround").buffer_setup({
						["m"] = {
							add = { { "%{" }, { "}" } },
						},
					})
				end,
				desc = "setup surround for eliixr",
			})
		end,
		opts = {
			move_cursor = "sticky",
		},
	},
}
