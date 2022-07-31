local Module = {}

Module.setup = function()
	local surround_group = vim.api.nvim_create_augroup("Zurround", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = surround_group,
		pattern = { "lua" },
		callback = function()
			vim.cmd([[ let b:surround_{char2nr('F')} = "function()\n \r \nend" ]])
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = surround_group,
		pattern = { "elixir" },
		callback = function()
			vim.cmd([[ let b:surround_{char2nr('m')} = "%{ \r }" ]])
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = surround_group,
		pattern = { "lua" },
		callback = function()
			vim.cmd([[ let b:surround_{char2nr('g')} = "\1Generic: \1<\r>" ]])
		end,
	})
end

return Module
