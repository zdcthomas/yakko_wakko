return {
	"nicwest/vim-camelsnek",
	-- cmd = { "Snek", "Pascal", "Camel", "Kebab" },
	keys = {

		{ "crs", ":Snek<CR>", mode = "n", { silent = true, desc = "snake_case" } },
		{ "crs", ":Snek<CR>", mode = "x", { silent = true, desc = "snake_case" } },
		{ "crp", ":Pascal<CR>", mode = "n", { silent = true, desc = "PascalCase" } },
		{ "crp", ":Pascal<CR>", mode = "x", { silent = true, desc = "PascalCase" } },
		{ "crc", ":Camel<CR>", mode = "n", { silent = true, desc = "camelCase" } },
		{ "crc", ":Camel<CR>", mode = "x", { silent = true, desc = "camel_case" } },
		{ "crk", ":Kebab<CR>", mode = "n", { silent = true, desc = "kebab-case" } },
		{ "crk", ":Kebab<CR>", mode = "x", { silent = true, desc = "kebab-case" } },
	},
	init = function()
		vim.g.camelsnek_alternative_camel_commands = 1
	end,
}
