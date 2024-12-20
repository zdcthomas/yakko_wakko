return {

	-- LSP servers and clients communicate which features they support through "capabilities".
	--  By default, Neovim supports a subset of the LSP specification.
	--  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
	--  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
	--
	-- This can vary by config, but in general for nvim-lspconfig:
	-- {
	-- 	"saghen/blink.cmp",
	-- 	version = "v0.*",
	-- 	-- !Important! Make sure you're using the latest release of LuaSnip
	-- 	-- `main` does not work at the moment
	-- 	dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
	-- 	opts = {
	-- 		keymap = { preset = "super-tab" },
	-- 		snippets = {
	-- 			expand = function(snippet)
	-- 				require("luasnip").lsp_expand(snippet)
	-- 			end,
	-- 			active = function(filter)
	-- 				if filter and filter.direction then
	-- 					return require("luasnip").jumpable(filter.direction)
	-- 				end
	-- 				return require("luasnip").in_snippet()
	-- 			end,
	-- 			jump = function(direction)
	-- 				require("luasnip").jump(direction)
	-- 			end,
	-- 		},
	-- 		sources = {
	-- 			default = { "lsp", "path", "luasnip", "buffer" },
	-- 		},
	-- 	},
	-- },
}
