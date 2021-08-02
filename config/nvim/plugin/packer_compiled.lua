-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = true
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
  everforest = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/everforest"
  },
  ["follow-md-links.nvim"] = {
    config = { "\27LJ\2\nç\1\0\0\6\0\t\0\f6\0\0\0'\2\1\0B\0\2\0016\0\2\0009\0\3\0009\0\4\0'\2\5\0'\3\6\0'\4\a\0005\5\b\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\16:edit #<cr>\t<bs>\5\20nvim_set_keymap\bapi\bvim\20follow-md-links\frequire\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/follow-md-links.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nç\t\0\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0=\3\17\2B\0\2\1K\0\1\0\fkeymaps\1\0\t\17n <leader>ga0<cmd>lua require\"gitsigns\".stage_hunk()<CR>\17n <leader>gb4<cmd>lua require\"gitsigns\".blame_line(true)<CR>\17n <leader>gp7<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>\17n <leader>gn7<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>\17n <leader>gs2<cmd>lua require\"gitsigns\".preview_hunk()<CR>\17v <leader>grT<cmd>lua require\"gitsigns\".reset_hunk({vim.fn.line(\".\"), vim.fn.line(\"v\")})<CR>\17n <leader>gu0<cmd>lua require\"gitsigns\".reset_hunk()<CR>\17n <leader>gr5<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>\17v <leader>gaT<cmd>lua require\"gitsigns\".stage_hunk({vim.fn.line(\".\"), vim.fn.line(\"v\")})<CR>\nsigns\1\0\1\nnumhl\2\17changedelete\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\6~\vlinehl\21GitSignsChangeLn\14topdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚Äæ\vlinehl\21GitSignsDeleteLn\vdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\6-\vlinehl\21GitSignsDeleteLn\vchange\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\badd\1\0\0\1\0\4\ahl\16GitSignsAdd\nnumhl\18GitSignsAddNr\ttext\6>\vlinehl\18GitSignsAddLn\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  gruvbox = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme gruvbox\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/gruvbox"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\ná\3\0\0\6\0\25\0!5\0\1\0005\1\0\0=\1\2\0005\1\3\0=\1\4\0005\1\5\0=\1\6\0005\1\b\0005\2\a\0=\2\t\0015\2\n\0=\2\v\0015\2\f\0006\3\r\0'\5\14\0B\3\2\0029\3\15\3>\3\2\2=\2\16\0014\2\0\0=\2\17\0015\2\18\0=\2\19\0015\2\20\0=\2\21\1=\1\22\0006\1\r\0'\3\23\0B\1\2\0029\1\24\1\18\3\0\0B\1\2\1K\0\1\0\nsetup\flualine\rsections\14lualine_z\1\2\0\0\rfiletype\14lualine_y\1\2\0\0\vbranch\14lualine_x\14lualine_c\vstatus\15lsp-status\frequire\1\2\0\0\tdiff\14lualine_b\1\2\0\0\rfilename\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\1\ntheme\rseoul256\23disabled_filetypes\1\2\0\0\rstartify\15extensions\1\0\0\1\2\0\0\rquickfix\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["moonlight.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/moonlight.nvim"
  },
  ["mrkdwn-utils"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17mrkdwn-utils\frequire\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/mrkdwn-utils"
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
    config = { "\27LJ\2\n÷\5\0\0\5\0\31\0(6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0025\3\t\0005\4\n\0=\4\v\3=\3\f\0025\3\r\0004\4\0\0=\4\14\0034\4\0\0=\4\15\3=\3\16\0025\3\17\0=\3\18\0025\3\19\0005\4\20\0=\4\21\3=\3\22\2B\0\2\0016\0\3\0'\2\23\0B\0\2\0029\0\24\0B\0\1\0025\1\29\0005\2\26\0005\3\27\0=\3\28\2=\2\30\1=\1\25\0K\0\1\0\17install_info\1\0\1\rfiletype\rmarkdown\nfiles\1\3\0\0\17src/parser.c\19src/scanner.cc\1\0\1\burl5https://github.com/ikatyang/tree-sitter-markdown\rmarkdown\23get_parser_configs\28nvim-treesitter.parsers\14highlight\fdisable\1\2\0\0\velixir\1\0\1\venable\2\21ensure_installed\1\t\0\0\trust\velixir\blua\tfish\tbash\15dockerfile\fcomment\fgraphql\frainbow\15termcolors\vcolors\1\0\3\19max_file_lines\3Ë\a\18extended_mode\2\venable\2\17query_linter\16lint_events\1\3\0\0\rBufWrite\15CursorHold\1\0\2\venable\2\21use_virtual_text\2\vindent\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire6 au! BufRead,BufNewFile *.fish set filetype=fish \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["startuptime.vim"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/opt/startuptime.vim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n˜\3\0\0\6\0\22\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\b\0'\2\5\0B\0\2\0016\0\t\0009\0\n\0009\0\v\0'\2\f\0'\3\r\0'\4\14\0005\5\15\0B\0\5\0016\0\t\0009\0\n\0009\0\v\0'\2\f\0'\3\16\0'\4\17\0005\5\18\0B\0\5\0016\0\t\0009\0\n\0009\0\v\0'\2\f\0'\3\19\0'\4\20\0005\5\21\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\31:Telescope grep_string<cr>\14<Leader>*\1\0\2\vsilent\2\fnoremap\2\29:Telescope live_grep<cr>\14<Leader>F\1\0\2\vsilent\2\fnoremap\2\30:Telescope find_files<cr>\14<Leader>p\6n\20nvim_set_keymap\bapi\bvim\19load_extension\15extensions\1\0\0\bfzf\1\0\0\1\0\4\28override_generic_sorter\1\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\nsetup\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["tokyonight.nvim"] = {
    config = { "\27LJ\2\nÊ\1\0\0\2\0\b\0\0216\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\1\0=\1\4\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0+\1\1\0=\1\6\0006\0\0\0009\0\1\0+\1\1\0=\1\a\0K\0\1\0 tokyonight_italic_variables tokyonight_italic_functions\31tokyonight_italic_comments\31tokyonight_italic_keywords\nnight\21tokyonight_style\6g\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/tokyonight.nvim"
  },
  ["vim-color-spring-night"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-color-spring-night"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-easy-align"] = {
    config = { "\27LJ\2\nî\1\0\0\6\0\t\0\0176\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\a\0'\3\4\0'\4\5\0005\5\b\0B\0\5\1K\0\1\0\1\0\1\fnoremap\1\6n\1\0\1\fnoremap\1\22<Plug>(EasyAlign)\aga\6x\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-easy-align"
  },
  ["vim-elixir"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-elixir"
  },
  ["vim-indent-object"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-indent-object"
  },
  ["vim-startify"] = {
    config = { "\27LJ\2\n‡\a\0\0\a\0\30\00086\0\0\0009\0\1\0004\1\6\0005\2\4\0005\3\3\0=\3\5\2>\2\1\0015\2\a\0005\3\6\0=\3\b\2>\2\2\0015\2\n\0005\3\t\0=\3\v\2>\2\3\0015\2\r\0005\3\f\0=\3\14\2>\2\4\0015\2\16\0005\3\15\0=\3\17\2>\2\5\1=\1\2\0006\0\0\0009\0\1\0004\1\3\0005\2\19\0005\3\20\0=\3\21\2>\2\1\0015\2\22\0004\3\3\0'\4\23\0006\5\0\0009\5\24\0059\5\25\5B\5\1\2&\4\5\4>\4\1\3=\3\21\2>\2\2\1=\1\18\0006\0\0\0009\0\1\0)\1\0\0=\1\26\0006\0\0\0009\0\1\0)\1\1\0=\1\27\0005\0\28\0006\1\0\0009\1\1\1=\0\29\1K\0\1\0\27startify_custom_header\1\16\0\0\20             &&\21           &&&&&\24         &&&\\/& &&&\26        &&|,/  |/& &&\30     *&_ &&/   /  /_&  &&!    &_\\\\    \\\\  { &|__&_&/_&$       \\\\_&_{*&/ /          &&&$    ,      `, \\{__&_&__&_&_/_&&\31   &        } }{      &\\\\'$            }{{         \\'_&__&%           {}{           \\ `&\\&&#           {{}             '&&#     ,--=-~{ .-^-\\_,_         # &,        `}                 \19   .        {  startify_change_to_vcs_root\28sttartify_change_to_dir\vgetcwd\afn\f   MRU \1\0\1\ttype\bdir\vheader\1\2\0\0\21   „ÇÅ„ÅÑ„Çå„ÅÑ \1\0\1\ttype\rcommands\19startify_lists\6D\1\0\0\1\3\0\0\tDmux\v:!dmux\6d\1\0\0\1\3\0\0\18Open dotfiles\25:!dmux ~/yakko_wakko\6c\1\0\0\1\3\0\0\19Compile Packer\19:PackerCompile\6s\1\0\0\1\3\0\0\16Sync Packer\16:PackerSync\6p\1\0\0\1\3\0\0\nFiles\26:Telescope find_files\22startify_commands\6g\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-vsnip"] = {
    config = { "\27LJ\2\nV\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0'~/yakko_wakko/config/nvim/snippets\22vsnip_snippet_dir\6g\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\nç\t\0\0\5\0\18\0\0216\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\14\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\3=\3\15\0025\3\16\0=\3\17\2B\0\2\1K\0\1\0\fkeymaps\1\0\t\17n <leader>ga0<cmd>lua require\"gitsigns\".stage_hunk()<CR>\17n <leader>gb4<cmd>lua require\"gitsigns\".blame_line(true)<CR>\17n <leader>gp7<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>\17n <leader>gn7<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>\17n <leader>gs2<cmd>lua require\"gitsigns\".preview_hunk()<CR>\17v <leader>grT<cmd>lua require\"gitsigns\".reset_hunk({vim.fn.line(\".\"), vim.fn.line(\"v\")})<CR>\17n <leader>gu0<cmd>lua require\"gitsigns\".reset_hunk()<CR>\17n <leader>gr5<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>\17v <leader>gaT<cmd>lua require\"gitsigns\".stage_hunk({vim.fn.line(\".\"), vim.fn.line(\"v\")})<CR>\nsigns\1\0\1\nnumhl\2\17changedelete\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\6~\vlinehl\21GitSignsChangeLn\14topdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\b‚Äæ\vlinehl\21GitSignsDeleteLn\vdelete\1\0\4\ahl\19GitSignsDelete\nnumhl\21GitSignsDeleteNr\ttext\6-\vlinehl\21GitSignsDeleteLn\vchange\1\0\4\ahl\19GitSignsChange\nnumhl\21GitSignsChangeNr\ttext\b‚îÇ\vlinehl\21GitSignsChangeLn\badd\1\0\0\1\0\4\ahl\16GitSignsAdd\nnumhl\18GitSignsAddNr\ttext\6>\vlinehl\18GitSignsAddLn\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.compe\frequire\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: gruvbox
time([[Config for gruvbox]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme gruvbox\bcmd\bvim\0", "config", "gruvbox")
time([[Config for gruvbox]], false)
-- Config for: vim-easy-align
time([[Config for vim-easy-align]], true)
try_loadstring("\27LJ\2\nî\1\0\0\6\0\t\0\0176\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\2\a\0'\3\4\0'\4\5\0005\5\b\0B\0\5\1K\0\1\0\1\0\1\fnoremap\1\6n\1\0\1\fnoremap\1\22<Plug>(EasyAlign)\aga\6x\20nvim_set_keymap\bapi\bvim\0", "config", "vim-easy-align")
time([[Config for vim-easy-align]], false)
-- Config for: tokyonight.nvim
time([[Config for tokyonight.nvim]], true)
try_loadstring("\27LJ\2\nÊ\1\0\0\2\0\b\0\0216\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\1\0=\1\4\0006\0\0\0009\0\1\0+\1\1\0=\1\5\0006\0\0\0009\0\1\0+\1\1\0=\1\6\0006\0\0\0009\0\1\0+\1\1\0=\1\a\0K\0\1\0 tokyonight_italic_variables tokyonight_italic_functions\31tokyonight_italic_comments\31tokyonight_italic_keywords\nnight\21tokyonight_style\6g\bvim\0", "config", "tokyonight.nvim")
time([[Config for tokyonight.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21config.lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: mrkdwn-utils
time([[Config for mrkdwn-utils]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17mrkdwn-utils\frequire\0", "config", "mrkdwn-utils")
time([[Config for mrkdwn-utils]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n÷\5\0\0\5\0\31\0(6\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0025\3\t\0005\4\n\0=\4\v\3=\3\f\0025\3\r\0004\4\0\0=\4\14\0034\4\0\0=\4\15\3=\3\16\0025\3\17\0=\3\18\0025\3\19\0005\4\20\0=\4\21\3=\3\22\2B\0\2\0016\0\3\0'\2\23\0B\0\2\0029\0\24\0B\0\1\0025\1\29\0005\2\26\0005\3\27\0=\3\28\2=\2\30\1=\1\25\0K\0\1\0\17install_info\1\0\1\rfiletype\rmarkdown\nfiles\1\3\0\0\17src/parser.c\19src/scanner.cc\1\0\1\burl5https://github.com/ikatyang/tree-sitter-markdown\rmarkdown\23get_parser_configs\28nvim-treesitter.parsers\14highlight\fdisable\1\2\0\0\velixir\1\0\1\venable\2\21ensure_installed\1\t\0\0\trust\velixir\blua\tfish\tbash\15dockerfile\fcomment\fgraphql\frainbow\15termcolors\vcolors\1\0\3\19max_file_lines\3Ë\a\18extended_mode\2\venable\2\17query_linter\16lint_events\1\3\0\0\rBufWrite\15CursorHold\1\0\2\venable\2\21use_virtual_text\2\vindent\1\0\0\1\0\1\venable\2\nsetup\28nvim-treesitter.configs\frequire6 au! BufRead,BufNewFile *.fish set filetype=fish \bcmd\bvim\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\ná\3\0\0\6\0\25\0!5\0\1\0005\1\0\0=\1\2\0005\1\3\0=\1\4\0005\1\5\0=\1\6\0005\1\b\0005\2\a\0=\2\t\0015\2\n\0=\2\v\0015\2\f\0006\3\r\0'\5\14\0B\3\2\0029\3\15\3>\3\2\2=\2\16\0014\2\0\0=\2\17\0015\2\18\0=\2\19\0015\2\20\0=\2\21\1=\1\22\0006\1\r\0'\3\23\0B\1\2\0029\1\24\1\18\3\0\0B\1\2\1K\0\1\0\nsetup\flualine\rsections\14lualine_z\1\2\0\0\rfiletype\14lualine_y\1\2\0\0\vbranch\14lualine_x\14lualine_c\vstatus\15lsp-status\frequire\1\2\0\0\tdiff\14lualine_b\1\2\0\0\rfilename\14lualine_a\1\0\0\1\2\0\0\tmode\foptions\1\0\1\ntheme\rseoul256\23disabled_filetypes\1\2\0\0\rstartify\15extensions\1\0\0\1\2\0\0\rquickfix\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: vim-startify
time([[Config for vim-startify]], true)
try_loadstring("\27LJ\2\n‡\a\0\0\a\0\30\00086\0\0\0009\0\1\0004\1\6\0005\2\4\0005\3\3\0=\3\5\2>\2\1\0015\2\a\0005\3\6\0=\3\b\2>\2\2\0015\2\n\0005\3\t\0=\3\v\2>\2\3\0015\2\r\0005\3\f\0=\3\14\2>\2\4\0015\2\16\0005\3\15\0=\3\17\2>\2\5\1=\1\2\0006\0\0\0009\0\1\0004\1\3\0005\2\19\0005\3\20\0=\3\21\2>\2\1\0015\2\22\0004\3\3\0'\4\23\0006\5\0\0009\5\24\0059\5\25\5B\5\1\2&\4\5\4>\4\1\3=\3\21\2>\2\2\1=\1\18\0006\0\0\0009\0\1\0)\1\0\0=\1\26\0006\0\0\0009\0\1\0)\1\1\0=\1\27\0005\0\28\0006\1\0\0009\1\1\1=\0\29\1K\0\1\0\27startify_custom_header\1\16\0\0\20             &&\21           &&&&&\24         &&&\\/& &&&\26        &&|,/  |/& &&\30     *&_ &&/   /  /_&  &&!    &_\\\\    \\\\  { &|__&_&/_&$       \\\\_&_{*&/ /          &&&$    ,      `, \\{__&_&__&_&_/_&&\31   &        } }{      &\\\\'$            }{{         \\'_&__&%           {}{           \\ `&\\&&#           {{}             '&&#     ,--=-~{ .-^-\\_,_         # &,        `}                 \19   .        {  startify_change_to_vcs_root\28sttartify_change_to_dir\vgetcwd\afn\f   MRU \1\0\1\ttype\bdir\vheader\1\2\0\0\21   „ÇÅ„ÅÑ„Çå„ÅÑ \1\0\1\ttype\rcommands\19startify_lists\6D\1\0\0\1\3\0\0\tDmux\v:!dmux\6d\1\0\0\1\3\0\0\18Open dotfiles\25:!dmux ~/yakko_wakko\6c\1\0\0\1\3\0\0\19Compile Packer\19:PackerCompile\6s\1\0\0\1\3\0\0\16Sync Packer\16:PackerSync\6p\1\0\0\1\3\0\0\nFiles\26:Telescope find_files\22startify_commands\6g\bvim\0", "config", "vim-startify")
time([[Config for vim-startify]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n˜\3\0\0\6\0\22\0)6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0005\4\3\0=\4\5\3=\3\a\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\b\0'\2\5\0B\0\2\0016\0\t\0009\0\n\0009\0\v\0'\2\f\0'\3\r\0'\4\14\0005\5\15\0B\0\5\0016\0\t\0009\0\n\0009\0\v\0'\2\f\0'\3\16\0'\4\17\0005\5\18\0B\0\5\0016\0\t\0009\0\n\0009\0\v\0'\2\f\0'\3\19\0'\4\20\0005\5\21\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\31:Telescope grep_string<cr>\14<Leader>*\1\0\2\vsilent\2\fnoremap\2\29:Telescope live_grep<cr>\14<Leader>F\1\0\2\vsilent\2\fnoremap\2\30:Telescope find_files<cr>\14<Leader>p\6n\20nvim_set_keymap\bapi\bvim\19load_extension\15extensions\1\0\0\bfzf\1\0\0\1\0\4\28override_generic_sorter\1\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: follow-md-links.nvim
time([[Config for follow-md-links.nvim]], true)
try_loadstring("\27LJ\2\nç\1\0\0\6\0\t\0\f6\0\0\0'\2\1\0B\0\2\0016\0\2\0009\0\3\0009\0\4\0'\2\5\0'\3\6\0'\4\a\0005\5\b\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\16:edit #<cr>\t<bs>\5\20nvim_set_keymap\bapi\bvim\20follow-md-links\frequire\0", "config", "follow-md-links.nvim")
time([[Config for follow-md-links.nvim]], false)
-- Config for: vim-vsnip
time([[Config for vim-vsnip]], true)
try_loadstring("\27LJ\2\nV\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0'~/yakko_wakko/config/nvim/snippets\22vsnip_snippet_dir\6g\bvim\0", "config", "vim-vsnip")
time([[Config for vim-vsnip]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'startuptime.vim'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

if should_profile then save_profiles(1) end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
