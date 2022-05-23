vim.cmd([[
  command! Yf :let @+ = expand("%")
  command! YF :let @+ = expand("%") . ":" . line(".")
  command! Irulan :!dmux ~/irulan/wiki
]])
