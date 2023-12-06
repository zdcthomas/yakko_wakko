local init_group_id = vim.api.nvim_create_augroup("InitGroup", { clear = true })

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
	desc = "Highlight yanked text regions",
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	group = init_group_id,
	desc = "Remove background for all WinSeparator sections",
	callback = function()
		vim.cmd("highlight WinSeparator guibg=None")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = init_group_id,
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
	desc = "Map q to close specific, read only buffers",
})

vim.api.nvim_create_autocmd("FileType", {
	group = init_group_id,
	pattern = { "hurl", "heex" },
	callback = function()
		vim.bo.commentstring = "# %s"
		vim.cmd(":TSEnable highlight")
	end,
	desc = "Set comment string for hurl files",
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	group = init_group_id,
	callback = function()
		vim.opt.formatoptions = vim.tbl_extend("force", vim.opt.formatoptions:get(), {
			o = false, -- O and o, don't continue comments
			r = true, -- Pressing Enter will continue comments
		})
	end,
	desc = "Set format options. Most ftplugins overwrite this, so we'll overwrite their overwrite!",
})

vim.api.nvim_create_autocmd(
	"FocusGained",
	{ command = "checktime", desc = "Check if buffer was changed", group = init_group_id }
)

-- This lets one delete entries from a quickfix list with `dd`
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = init_group_id,
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
	desc = "Delete entry from Quickfix list",
})

vim.api.nvim_create_autocmd("RecordingEnter", {
	pattern = "*",
	desc = "Fix broken macro recording notification for cmdheight 0, pt1",
	callback = function()
		vim.opt_local.cmdheight = 1
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	pattern = "*",
	desc = "Fix broken macro recording notification for cmdheight 0, pt2",
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
