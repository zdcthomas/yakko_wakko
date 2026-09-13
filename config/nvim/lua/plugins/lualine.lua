-- word count for the daily-500-words component; skips #+ front matter
-- lines so only prose counts toward the goal
local function prose_words()
	local words = 0
	for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
		if not line:match("^%s*#%+") then
			local _, n = line:gsub("%S+", "")
			words = words + n
		end
	end
	return words
end

return {
	"nvim-lualine/lualine.nvim",
	event = "BufReadPost",
	opts = {
		extensions = { "quickfix", "man", "oil", "lazy" },
		disabled_filetypes = { "startify" },
		options = {
			theme = "auto",
			section_separators = { left = "", right = "" },

			refresh = {
				statusline = 200, -- Note these are in mili second and default is 1000
			},
			component_separators = { left = "", right = "" },
			globalstatus = true,
		},
		sections = {
			lualine_a = {
				{
					"filename",
					file_status = true,
					path = 1,
					shorting_target = 40,
				},
			},
			lualine_b = { "diff" },
			lualine_c = {
				{
					require("lazy.status").updates,
					cond = require("lazy.status").has_updates,
					color = { fg = "#ff9e64" },
				},
				{
					"diagnostics",
					-- sources = { "nvim_lsp", "nvim_diagnositc" },
					colored = true,
				},
			},
			lualine_x = {
				{
					-- daily-500-words progress; only shows in files under
					-- writing/500-words/ so the statusline stays quiet elsewhere
					function()
						return ("%d/500 words"):format(prose_words())
					end,
					cond = function()
						return vim.api.nvim_buf_get_name(0):find("/writing/500%-words/") ~= nil
					end,
					color = function()
						return prose_words() >= 500 and { fg = "#9ece6a" } or nil
					end,
				},
				"location",
				"progress",
			},
			lualine_y = { "encoding" },
			lualine_z = { { "filetype", colored = false } },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "diff" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "windows" },
		},
	},
}
