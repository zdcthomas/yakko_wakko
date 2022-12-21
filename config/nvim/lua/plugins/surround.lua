return {
	"kylechui/nvim-surround",
	event = "BufReadPost",
	config = function()
		require("nvim-surround").setup({})

		local surround_group = vim.api.nvim_create_augroup("zdcthomasSurroundGroup", { clear = true })

		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = surround_group,
			pattern = { "markdown" },
			callback = function()
				require("nvim-surround").buffer_setup({
					surrounds = {
						["l"] = {
							add = function()
								local clipboard = vim.fn.getreg("+"):gsub("\n", "")
								return {
									{ "[" },
									{ "](" .. clipboard .. ")" },
								}
							end,
							find = "%b[]%b()",
							delete = "^(%[)().-(%]%b())()$",
							change = {
								target = "^()()%b[]%((.-)()%)$",
								replacement = function()
									local clipboard = vim.fn.getreg("+"):gsub("\n", "")
									return {
										{ "" },
										{ clipboard },
									}
								end,
							},
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
							add = { "vim.pretty_print(", ")" },
							find = "vim%.pretty_print%b()",
							delete = "^(vim%.pretty_print%()().-(%))()$",
							change = {
								target = "^(vim%.pretty_print%()().-(%))()$",
							},
						},
					},
				})
			end,
			desc = "setup surround for eliixr",
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
}
