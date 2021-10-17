local conf = {}
-- If you start to lazy load cmp, this will break cause you're dumb
-- sincerely, Zach from 10-17-2021

local cmp = require('cmp')

local function check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local function tab_handler(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif vim.fn['vsnip#available']() == 1 then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-expand-or-jump)', true, true, true), '')
  elseif check_back_space() then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n')
  else
    fallback()
  end
end

local function shift_tab_handler(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>(vsnip-jump-prev)', true, true, true), '')
  elseif check_back_space() then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, true, true), 'n')
  else
    fallback()
  end
end

local function mappings()
  return {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }),
    ['<Tab>'] = tab_handler,
    ['<S-Tab>'] = shift_tab_handler,
  }
end

local function snippet_func(args)
  vim.fn['vsnip#anonymous'](args.body)
end

local function sources()
  return {
      {name = 'nvim_lsp',
        opts = {
          all_panes = true
        }
      },
      {name = 'vsnip'},
      {name = 'buffer'},
      {name = 'path'},
      {name = 'tmux'},
      {name = 'calc'},
    }
end

function conf.setup()
  cmp.setup {
    snippet = {
      expand = snippet_func
    },
    preselect = cmp.PreselectMode.None,
    mapping = mappings(),
    sources = sources(),
  }
end

return conf
