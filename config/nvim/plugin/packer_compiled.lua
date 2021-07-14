-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/zacharythomas/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/zacharythomas/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/zacharythomas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/zacharythomas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/zacharythomas/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  gruvbox = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme gruvbox\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/gruvbox"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.compe\frequire\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21config.lspconfig\frequire\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n—\2\0\0\5\0\14\0\0196\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0024\3\0\0=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\14highlight\fdisable\1\2\0\0\velixir\1\0\1\venable\2\19ignore_install\21ensure_installed\1\0\0\1\5\0\0\trust\velixir\blua\tfish\nsetup\28nvim-treesitter.configs\frequire6 au! BufRead,BufNewFile *.fish set filetype=fish \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n›\1\0\0\6\0\t\0\f6\0\0\0'\2\1\0B\0\2\0016\0\2\0009\0\3\0009\0\4\0'\2\5\0'\3\6\0'\4\a\0005\5\b\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\30:Telescope find_files<cr>\14<Leader>p\6n\20nvim_set_keymap\bapi\bvim\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-elixir"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-elixir"
  },
  ["vim-gitgutter"] = {
    config = { "\27LJ\2\n²\5\0\0\4\0\4\0\a6\0\0\0009\0\1\0009\0\2\0'\2\3\0+\3\1\0B\0\3\1K\0\1\0€\5        set updatetime=100\n        let g:gitgutter_map_keys = 0\n        command! Gqf GitGutterQuickFix | copen\n        nnoremap <Leader>gc :Gqf<CR>\n        nnoremap <Leader>ga :GitGutterStageHunk<CR>\n        nnoremap <Leader>gu :GitGutterUndoHunk<CR>\n        nnoremap <Leader>gn :GitGutterNextHunk<CR>\n        nnoremap <Leader>gp :GitGutterPrevHunk<CR>\n        nnoremap <Leader>gs :GitGutterPreviewHunk<CR>\n        omap ih <Plug>(GitGutterTextObjectInnerPending)\n        omap ah <Plug>(GitGutterTextObjectOuterPending)\n        xmap ih <Plug>(GitGutterTextObjectInnerVisual)\n        xmap ah <Plug>(GitGutterTextObjectOuterVisual)\n      \14nvim_exec\bapi\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-gitgutter"
  },
  ["vim-indent-object"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-indent-object"
  },
  ["vim-vsnip"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n›\1\0\0\6\0\t\0\f6\0\0\0'\2\1\0B\0\2\0016\0\2\0009\0\3\0009\0\4\0'\2\5\0'\3\6\0'\4\a\0005\5\b\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\30:Telescope find_files<cr>\14<Leader>p\6n\20nvim_set_keymap\bapi\bvim\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.compe\frequire\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21config.lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: vim-gitgutter
time([[Config for vim-gitgutter]], true)
try_loadstring("\27LJ\2\n²\5\0\0\4\0\4\0\a6\0\0\0009\0\1\0009\0\2\0'\2\3\0+\3\1\0B\0\3\1K\0\1\0€\5        set updatetime=100\n        let g:gitgutter_map_keys = 0\n        command! Gqf GitGutterQuickFix | copen\n        nnoremap <Leader>gc :Gqf<CR>\n        nnoremap <Leader>ga :GitGutterStageHunk<CR>\n        nnoremap <Leader>gu :GitGutterUndoHunk<CR>\n        nnoremap <Leader>gn :GitGutterNextHunk<CR>\n        nnoremap <Leader>gp :GitGutterPrevHunk<CR>\n        nnoremap <Leader>gs :GitGutterPreviewHunk<CR>\n        omap ih <Plug>(GitGutterTextObjectInnerPending)\n        omap ah <Plug>(GitGutterTextObjectOuterPending)\n        xmap ih <Plug>(GitGutterTextObjectInnerVisual)\n        xmap ah <Plug>(GitGutterTextObjectOuterVisual)\n      \14nvim_exec\bapi\bvim\0", "config", "vim-gitgutter")
time([[Config for vim-gitgutter]], false)
-- Config for: gruvbox
time([[Config for gruvbox]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme gruvbox\bcmd\bvim\0", "config", "gruvbox")
time([[Config for gruvbox]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n—\2\0\0\5\0\14\0\0196\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0024\3\0\0=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\14highlight\fdisable\1\2\0\0\velixir\1\0\1\venable\2\19ignore_install\21ensure_installed\1\0\0\1\5\0\0\trust\velixir\blua\tfish\nsetup\28nvim-treesitter.configs\frequire6 au! BufRead,BufNewFile *.fish set filetype=fish \bcmd\bvim\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
