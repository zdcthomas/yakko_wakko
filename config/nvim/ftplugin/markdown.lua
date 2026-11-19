vim.opt_local.spell = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- gq wraps with one sentence per line through enjamb (my mdslw fork). The
-- formatexpr keeps tables whole and keeps the blank lines around the range.
-- See utils/enjamb.lua.
-- Marksman offers no range formatting, so the LSP attach does not replace it.
vim.opt_local.formatexpr = "v:lua.require'utils.enjamb'.formatexpr()"
