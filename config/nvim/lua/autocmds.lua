InitGroupId = vim.api.nvim_create_augroup("InitGroup", { clear = true })

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	group = InitGroupId,
	callback = function()
		vim.cmd("highlight WinSeparator guibg=None")
	end,
})
-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter", "CmdlineLeave" }, {
	group = InitGroupId,
	pattern = "*",
	command = "set cursorline",
	desc = "Enable cursorline",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave", "CmdlineEnter" }, {
	group = InitGroupId,
	pattern = "*",
	command = "set nocursorline",
	desc = "Disable cursorline",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = InitGroupId,
	pattern = { "help", "startuptime", "qf", "lspinfo", "man" },
	callback = function()
		vim.keymap.set("n", "q", function()
			vim.cmd([[close]])
		end, {
			noremap = true,
			silent = true,
			buffer = true,
		})
	end,
	desc = "Map q to close buffer",
})

vim.api.nvim_create_autocmd(
	"FocusGained",
	{ command = "checktime", desc = "Check if buffer was changed", group = InitGroupId }
)
