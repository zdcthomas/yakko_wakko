return {
	"nicwest/vim-camelsnek",
	keys = {
		{ "crs", ":Snek<CR>", mode = { "n", "x" }, { silent = true, desc = "snake_case" } },
		{ "crS", ":Screm<CR>", mode = { "n", "x" }, { silent = true, desc = "snake_case" } },
		{ "crp", ":Pascal<CR>", mode = { "n", "x" }, { silent = true, desc = "PascalCase" } },
		{ "crc", ":Camel<CR>", mode = { "n", "x" }, { silent = true, desc = "camelCase" } },
		{ "crk", ":Kebab<CR>", mode = { "n", "x" }, { silent = true, desc = "kebab-case" } },
	},
	init = function()
		vim.g.camelsnek_alternative_camel_commands = 1
	end,
}
