local pipe = "/tmp/nvim.pipe"
vim.api.nvim_command('echo serverstart("' .. pipe .. '")')

-- set softtabstop=0 noexpandtab
vim.bo.softtabstop = 0
vim.bo.expandtab = false
vim.bo.shiftwidth = 4
