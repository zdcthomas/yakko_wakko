vim.opt_local.spell = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- gq wraps with one sentence per line. A non-empty formatexpr wins over
-- formatprg, so keep it empty. Marksman offers no range formatting, so
-- the LSP attach does not set it back.
vim.opt_local.formatprg = "mdslw --max-width 100"
vim.opt_local.formatexpr = ""
