local function setup()
	require("nvim-treesitter.configs").setup({
		indent = { enable = true },
		autopairs = { enable = true },
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
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
			max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
		},
		context_commentstring = {
			enable = true,
		},
		-- TODO: Figure out if this is slowing this down
		ensure_installed = {
			"bash",
			"comment",
			"dockerfile",
			"fennel",
			"fish",
			"gleam",
			"go",
			"gomod",
			"graphql",
			"help",
			"html",
			"http",
			"javascript",
			"json",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"nix",
			"norg",
			"org",
			"python",
			"regex",
			"ruby",
			"rust",
			"toml",
			"tsx",
			"typescript",
			"vim",
		},
		highlight = {
			enable = true,
			-- disable = { "elixir" },
			-- additional_vim_regex_highlighting = { "org" },
		},
	})
end

return {
	"nvim-treesitter/nvim-treesitter",
	dev = false,
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		"HiPhish/nvim-ts-rainbow2",
		"JoosepAlviste/nvim-ts-context-commentstring",
		{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
	},
	config = function()
		setup()
	end,
}
