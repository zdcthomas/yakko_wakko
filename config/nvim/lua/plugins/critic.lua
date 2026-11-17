-- CriticMarkup ({>> comment <<}, {++ add ++}, {-- del --}, {~~ a ~> b ~~}, {== hl ==})
-- for review comments in Markdown docs. Zach's fork: every keymap is an operator
-- (<Leader>mh{motion}, <Leader>mhh for the line, <Leader>mi_ for an insertion line).
-- Keymaps live under <Leader>m (free; crates.nvim owns <Leader>c in Cargo.toml).
-- conceal = false: with true the plugin sets conceallevel = 2 on every Markdown
-- window, which also hides code fences, inline-code backticks, emphasis markers
-- and link targets.
return {
	"zdcthomas/critic.nvim",
	branch = "operator-mappings",
	ft = { "markdown" },
	opts = {
		prefix = "<Leader>m",
		conceal = false,
	},
}
