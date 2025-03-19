local bracket_keys = {}

local config = {
	-- First-level elements are tables describing behavior of a target:
	--
	-- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
	--   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
	--   Supply empty string `''` to not create mappings.
	--
	-- - <options> - table overriding target options.
	--
	-- See `:h MiniBracketed.config` for more info.

	buffer = { suffix = "b", options = {} },
	comment = { suffix = "c", options = {} },
	conflict = { suffix = "x", options = {} },
	indent = { suffix = "i", options = {} },
	jump = { suffix = "j", options = {} },
	location = { suffix = "l", options = {} },
	quickfix = { suffix = "q", options = {} },
	window = { suffix = "w", options = {} },
	yank = { suffix = "", options = {} },
	oldfile = { suffix = "", options = {} },
	diagnostic = { suffix = "", options = {} },
	file = { suffix = "", options = {} },
	undo = { suffix = "", options = {} },
	treesitter = { suffix = "", options = {} },
}

for _, value in pairs(config) do
	if value.suffix ~= "" then
		bracket_keys[#bracket_keys + 1] = "[" .. value.suffix
		bracket_keys[#bracket_keys + 1] = "]" .. value.suffix
		bracket_keys[#bracket_keys + 1] = "[" .. string.upper(value.suffix)
		bracket_keys[#bracket_keys + 1] = "]" .. string.upper(value.suffix)
	end
end

return {
	{
		"echasnovski/mini.bracketed",
		version = false,
		keys = bracket_keys,
		config = function()
			require("mini.bracketed").setup(config)
		end,
	},
}
