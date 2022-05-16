local Conf = {}

function Conf.setup()
	require("nvim-treesitter.configs").setup({
		indent = {
			enable = true,
		},
		autopairs = { enable = true },
		query_linter = {
			enable = true,
			use_virtual_text = true,
			lint_events = { "BufWrite", "CursorHold" },
		},
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
			max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
		},
		ensure_installed = {
			"bash",
			"comment",
			"dockerfile",
			"fish",
			"gleam",
			"graphql",
			"lua",
			"norg",
			"rust",
		},
		highlight = {
			enable = true,
			disable = { "elixir" },
		},
	})

	require("nvim-treesitter.parsers").get_parser_configs().markdown = {
		install_info = {
			url = "https://github.com/ikatyang/tree-sitter-markdown",
			files = { "src/parser.c", "src/scanner.cc" },
		},
		filetype = "markdown",
	}
end

return Conf
