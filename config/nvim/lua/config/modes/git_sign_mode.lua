local req = "gitsigns.nvim"
if not PluginIsLoaded(req) then
	return function()
		vim.notify(req .. " Is not loaded", "ERROR")
	end
end

return function()
	local git_mappings = {
		["n"] = require("gitsigns.actions").next_hunk,
		["p"] = require("gitsigns.actions").prev_hunk,
		["a"] = require("gitsigns").stage_hunk,
		-- ["v <leader>ga"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		["r"] = require("gitsigns").undo_stage_hunk,
		["u"] = require("gitsigns").reset_hunk,
		-- ["v <leader>gr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		["d"] = require("gitsigns").preview_hunk,
		["b"] = require("gitsigns").blame_line,
		["q"] = require("gitsigns").setqflist,
	}
	require("libmodal").mode.enter("GIT", git_mappings)
end
