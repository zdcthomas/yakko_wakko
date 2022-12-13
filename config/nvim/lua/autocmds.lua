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

-- vim.api.nvim_create_autocmd("CursorMoved", {
-- 	group = InitGroupId,
-- 	callback = function()
-- 		local ns = vim.api.nvim_create_namespace("diag_lines")

-- 		local timer = vim.loop.new_timer()
-- 		timer:start(
-- 			100,
-- 			0,
-- 			vim.schedule_wrap(function()
-- 				require("utils.render_diagnostic").hide(ns, 0)
-- 			end)
-- 		)
-- 		-- vim.api.nvim_win_get_cursor(0)
-- 	end,
-- })

-- vim.api.nvim_create_autocmd("CursorHold", {
-- 	pattern = "*",
-- 	group = InitGroupId,
-- 	callback = function()
-- 		local diagnostic = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
-- 		local ns = vim.api.nvim_create_namespace("diag_lines")
-- 		-- require("utils.render_diagnostic").hide(ns, 0)
-- 		require("utils.render_diagnostic").show(ns, 0, diagnostic)
-- 	end,
-- })

-- show cursor line only in active window
-- vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter", "CmdlineLeave" }, {
-- 	group = InitGroupId,
-- 	pattern = "*",
-- 	command = "set cursorline",
-- 	desc = "Enable cursorline",
-- })

-- vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave", "CmdlineEnter" }, {
-- 	group = InitGroupId,
-- 	pattern = "*",
-- 	command = "set nocursorline",
-- 	desc = "Disable cursorline",
-- })

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

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	group = InitGroupId,
	callback = function()
		vim.opt.formatoptions = vim.tbl_extend("force", vim.opt.formatoptions:get(), {
			o = false, -- O and o, don't continue comments
			r = true, -- Pressing Enter will continue comments
		})
	end,
	desc = "Most ftplugins overwrite, so we'll overwrite their overwrite!",
})

vim.api.nvim_create_autocmd(
	"FocusGained",
	{ command = "checktime", desc = "Check if buffer was changed", group = InitGroupId }
)

-- This lets one delete entries from a quickfix list with `dd`
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = InitGroupId,
	pattern = { "qf" },
	callback = function()
		vim.keymap.set("n", "dd", function()
			local current_quick_fix_index = vim.fn.line(".")
			local quickfix_list = vim.fn.getqflist()
			table.remove(quickfix_list, current_quick_fix_index)
			vim.fn.setqflist(quickfix_list, "r")
			vim.fn.execute(current_quick_fix_index .. "cfirst")
			vim.cmd("copen")
		end, { buffer = true })
	end,
	desc = "Map q to close buffer",
})

vim.api.nvim_create_autocmd("RecordingEnter", {
	pattern = "*",
	callback = function()
		vim.opt_local.cmdheight = 1
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	pattern = "*",
	callback = function()
		local timer = vim.loop.new_timer()
		-- NOTE: Timer is here because we need to close cmdheight AFTER
		-- the macro is ended, not during the Leave event
		timer:start(
			50,
			0,
			vim.schedule_wrap(function()
				vim.opt_local.cmdheight = 0
			end)
		)
	end,
})
