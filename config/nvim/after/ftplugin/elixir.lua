local surround = Pquire("nvim-surround")
if surround then
	require("nvim-surround").buffer_setup({

		["m"] = {
			add = { { "%{" }, { "}" } },
		},
		surrounds = {
			-- ["p"] = {
			-- 	add = { "vim.pretty_print(", ")" },
			-- 	find = "vim%.pretty_print%b()",
			-- 	delete = "^(vim%.pretty_print%()().-(%))()$",
			-- 	change = {
			-- 		target = "^(vim%.pretty_print%()().-(%))()$",
			-- 	},
			-- },
		},
	})
end
