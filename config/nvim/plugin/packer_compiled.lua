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
  ["completion-nvim"] = {
    config = { "\27LJ\2\nÄ\3\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0¤\3        \" Use <Tab> and <S-Tab> to navigate through popup menu\n        inoremap <expr> <Tab>   pumvisible() ? \"\\<C-n>\" : \"\\<Tab>\"\n        inoremap <expr> <S-Tab> pumvisible() ? \"\\<C-p>\" : \"\\<S-Tab>\"\n\n        \" Set completeopt to have a better completion experience\n        set completeopt=menuone,noinsert,noselect\n\n        \" Avoid showing message extra message when using completion\n        set shortmess+=c\n      \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/completion-nvim"
  },
  gruvbox = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme gruvbox\bcmd\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/gruvbox"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\nA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1À\24nvim_buf_set_option\bapi\bvimA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1À\24nvim_buf_set_keymap\bapi\bvimÁ\n\1\2\n\0(\0n3\2\0\0003\3\1\0\18\4\2\0'\6\2\0'\a\3\0B\4\3\1\18\4\3\0'\6\4\0'\a\5\0'\b\6\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\b\0'\b\t\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\n\0'\b\v\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\f\0'\b\r\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\14\0'\b\15\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\16\0'\b\17\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\18\0'\b\19\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\20\0'\b\21\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\22\0'\b\23\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\24\0'\b\25\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\26\0'\b\27\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\28\0'\b\29\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\30\0'\b\31\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a \0'\b!\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\"\0'\b#\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a$\0'\b%\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a&\0'\b'\0006\t\a\0B\4\5\0012\0\0€K\0\1\0*<cmd>lua vim.lsp.buf.formatting()<CR>\r<space>f2<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>\r<space>q0<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d0<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d<<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>\r<space>e*<cmd>lua vim.lsp.buf.references()<CR>\agr+<cmd>lua vim.lsp.buf.code_action()<CR>\14<space>ca&<cmd>lua vim.lsp.buf.rename()<CR>\14<space>rn/<cmd>lua vim.lsp.buf.type_definition()<CR>\r<space>DJ<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>\14<space>wl7<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>\14<space>wr4<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>\14<space>wa.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>.<cmd>lua vim.lsp.buf.implementation()<CR>\agi%<Cmd>lua vim.lsp.buf.hover()<CR>\6K*<Cmd>lua vim.lsp.buf.definition()<CR>\agd\topts+<Cmd>lua vim.lsp.buf.declaration()<CR>\agD\6n\27v:lua.vim.lsp.omnifunc\romnifunc\0\0Ô\2\1\0\f\0\14\0\0286\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\0016\0\4\0'\2\5\0B\0\2\0023\1\6\0005\2\a\0006\3\b\0\18\5\2\0B\3\2\4X\6\b€8\b\a\0009\b\t\b5\n\n\0006\v\v\0=\v\v\n5\v\f\0=\v\r\nB\b\2\1E\6\3\3R\6öK\0\1\0\nflags\1\0\1\26debounce_text_changes\3–\1\14on_attach\1\0\0\nsetup\vipairs\1\4\0\0\relixirls\18rust_analyzer\rtsserver\0\14lspconfig\frequire6 au! BufRead,BufNewFile *.ex set filetype=elixir 4 au! BufRead,BufNewFile *.rs set filetype=rust \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/zacharythomas/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15lspinstall\frequire\0" },
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
  }
}

time([[Defining packer_plugins]], false)
-- Config for: completion-nvim
time([[Config for completion-nvim]], true)
try_loadstring("\27LJ\2\nÄ\3\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0¤\3        \" Use <Tab> and <S-Tab> to navigate through popup menu\n        inoremap <expr> <Tab>   pumvisible() ? \"\\<C-n>\" : \"\\<Tab>\"\n        inoremap <expr> <S-Tab> pumvisible() ? \"\\<C-p>\" : \"\\<S-Tab>\"\n\n        \" Set completeopt to have a better completion experience\n        set completeopt=menuone,noinsert,noselect\n\n        \" Avoid showing message extra message when using completion\n        set shortmess+=c\n      \bcmd\bvim\0", "config", "completion-nvim")
time([[Config for completion-nvim]], false)
-- Config for: nvim-lspinstall
time([[Config for nvim-lspinstall]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15lspinstall\frequire\0", "config", "nvim-lspinstall")
time([[Config for nvim-lspinstall]], false)
-- Config for: gruvbox
time([[Config for gruvbox]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\24colorscheme gruvbox\bcmd\bvim\0", "config", "gruvbox")
time([[Config for gruvbox]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n—\2\0\0\5\0\14\0\0196\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\3\0'\2\4\0B\0\2\0029\0\5\0005\2\a\0005\3\6\0=\3\b\0024\3\0\0=\3\t\0025\3\n\0005\4\v\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\14highlight\fdisable\1\2\0\0\velixir\1\0\1\venable\2\19ignore_install\21ensure_installed\1\0\0\1\5\0\0\trust\velixir\blua\tfish\nsetup\28nvim-treesitter.configs\frequire6 au! BufRead,BufNewFile *.fish set filetype=fish \bcmd\bvim\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n›\1\0\0\6\0\t\0\f6\0\0\0'\2\1\0B\0\2\0016\0\2\0009\0\3\0009\0\4\0'\2\5\0'\3\6\0'\4\a\0005\5\b\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\30:Telescope find_files<cr>\14<Leader>p\6n\20nvim_set_keymap\bapi\bvim\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\nA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1À\24nvim_buf_set_option\bapi\bvimA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1À\24nvim_buf_set_keymap\bapi\bvimÁ\n\1\2\n\0(\0n3\2\0\0003\3\1\0\18\4\2\0'\6\2\0'\a\3\0B\4\3\1\18\4\3\0'\6\4\0'\a\5\0'\b\6\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\b\0'\b\t\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\n\0'\b\v\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\f\0'\b\r\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\14\0'\b\15\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\16\0'\b\17\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\18\0'\b\19\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\20\0'\b\21\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\22\0'\b\23\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\24\0'\b\25\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\26\0'\b\27\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\28\0'\b\29\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\30\0'\b\31\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a \0'\b!\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a\"\0'\b#\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a$\0'\b%\0006\t\a\0B\4\5\1\18\4\3\0'\6\4\0'\a&\0'\b'\0006\t\a\0B\4\5\0012\0\0€K\0\1\0*<cmd>lua vim.lsp.buf.formatting()<CR>\r<space>f2<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>\r<space>q0<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d0<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d<<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>\r<space>e*<cmd>lua vim.lsp.buf.references()<CR>\agr+<cmd>lua vim.lsp.buf.code_action()<CR>\14<space>ca&<cmd>lua vim.lsp.buf.rename()<CR>\14<space>rn/<cmd>lua vim.lsp.buf.type_definition()<CR>\r<space>DJ<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>\14<space>wl7<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>\14<space>wr4<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>\14<space>wa.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>.<cmd>lua vim.lsp.buf.implementation()<CR>\agi%<Cmd>lua vim.lsp.buf.hover()<CR>\6K*<Cmd>lua vim.lsp.buf.definition()<CR>\agd\topts+<Cmd>lua vim.lsp.buf.declaration()<CR>\agD\6n\27v:lua.vim.lsp.omnifunc\romnifunc\0\0Ô\2\1\0\f\0\14\0\0286\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\1\0'\2\3\0B\0\2\0016\0\4\0'\2\5\0B\0\2\0023\1\6\0005\2\a\0006\3\b\0\18\5\2\0B\3\2\4X\6\b€8\b\a\0009\b\t\b5\n\n\0006\v\v\0=\v\v\n5\v\f\0=\v\r\nB\b\2\1E\6\3\3R\6öK\0\1\0\nflags\1\0\1\26debounce_text_changes\3–\1\14on_attach\1\0\0\nsetup\vipairs\1\4\0\0\relixirls\18rust_analyzer\rtsserver\0\14lspconfig\frequire6 au! BufRead,BufNewFile *.ex set filetype=elixir 4 au! BufRead,BufNewFile *.rs set filetype=rust \bcmd\bvim\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
