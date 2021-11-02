vim.o.spell = true

if vim.fn.exists("g:started_by_firenvim") then
	vim.bo.laststatus = 0
	vim.bo.nonumber = true
	vim.bo.norelativenumber = true
	vim.bo.noruler = true
	vim.bo.noshowcmd = true

	vim.api.nvim_set_keymap("i", "<tab> <c-n>", {})
	vim.api.nvim_set_keymap("i", "<s-tab> <c-p>", {})
end
