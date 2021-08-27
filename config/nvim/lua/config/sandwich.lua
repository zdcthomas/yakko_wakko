local C = {}
function C.setup()
  vim.g.sandwich_no_default_key_mappings = 1
  vim.g.operator_sandwich_no_default_key_mappings = 1
  vim.g.textobj_sandwich_no_default_key_mappings = 1
  vim.api.nvim_set_keymap('n', 'ys', '<Plug>(operator-sandwich-add)', {})
  vim.api.nvim_set_keymap('o', 'ys', '<SID>line :normal! ^vg_<CR>', {noremap = true})
  vim.api.nvim_set_keymap('n', 'yss', "<Plug>(operator-sandwich-add)<SID>line", {silent = true})
  -- vim.cmd("nmap <silent> yss <Plug>(operator-sandwich-add)<SID>line")
  vim.api.nvim_set_keymap('o', '<SID>gul', 'g_', {noremap = true})
  vim.api.nvim_set_keymap('n', 'yS', 'ys<SID>gul', {})

  vim.api.nvim_set_keymap('n', 'ds', '<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)', {})
  vim.api.nvim_set_keymap('n', 'dss', '<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)', {})
  vim.api.nvim_set_keymap('n', 'cs', '<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)', {})
  vim.api.nvim_set_keymap('n', 'css', '<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)', {})
  vim.api.nvim_set_keymap('x', 'S', '<Plug>(operator-sandwich-add)', {})

  vim.api.nvim_set_keymap('x', 'is', '<Plug>(textobj-sandwich-query-i)', {})
  vim.api.nvim_set_keymap('x', 'as', '<Plug>(textobj-sandwich-query-a)', {})
  vim.api.nvim_set_keymap('o', 'is', '<Plug>(textobj-sandwich-query-i)', {})
  vim.api.nvim_set_keymap('o', 'as', '<Plug>(textobj-sandwich-query-a)', {})

  vim.api.nvim_set_keymap('x', 'iss', '<Plug>(textobj-sandwich-auto-i)', {})
  vim.api.nvim_set_keymap('x', 'ass', '<Plug>(textobj-sandwich-auto-a)', {})
  vim.api.nvim_set_keymap('o', 'iss', '<Plug>(textobj-sandwich-auto-i)', {})
  vim.api.nvim_set_keymap('o', 'ass', '<Plug>(textobj-sandwich-auto-a)', {})

  vim.api.nvim_set_keymap('x', 'im', '<Plug>(textobj-sandwich-literal-query-i)', {})
  vim.api.nvim_set_keymap('x', 'am', '<Plug>(textobj-sandwich-literal-query-a)', {})
  vim.api.nvim_set_keymap('o', 'im', '<Plug>(textobj-sandwich-literal-query-i)', {})
  vim.api.nvim_set_keymap('o', 'am', '<Plug>(textobj-sandwich-literal-query-a)', {})

  vim.cmd([[
  runtime autoload/repeat.vim
  if hasmapto('<Plug>(RepeatDot)')
  nmap . <Plug>(operator-sandwich-predot)<Plug>(RepeatDot)
  else
  nmap . <Plug>(operator-sandwich-dot)
  endif

  function! StructInput() abort
  let s:StructLast = input('Struct: ')
  if s:StructLast !=# ''
  let struct = printf('%%%s{', s:StructLast)
  else
  throw 'OperatorSandwichCancel'
  endif
  return [struct, '}']
  endfunction

  function! GenericInput() abort
  let s:GenericLast = input('Generic: ')
  if s:GenericLast !=# ''
  let struct = printf('%s<', s:GenericLast)
  else
  throw 'OperatorSandwichCancel'
  endif
  return [struct, '>']
  endfunction
  ]])
  vim.g['sandwich#magicchar#f#patterns'] = {{
    header = [[\h*\:*\h*]],
    bra    = '(',
    ket    = ')',
    footer = '',
  }}
  vim.cmd("let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)")
  vim.cmd([[ let g:sandwich#recipes += [ { 'buns'    : ['%{', '}'], 'input'   : ['m'], 'nesting' : 1 }, { 'buns'    : 'StructInput()', 'kind'    : ['add', 'replace', 'delete'], 'action'  : ['add'], 'input'   : ['s'], 'listexpr': 1, 'nesting' : 1 }, { 'buns'    : 'GenericInput()', 'kind'    : ['add', 'replace'], 'action'  : ['add'], 'input'   : ['g'], 'listexpr': 1, 'nesting' : 1 }, { 'buns'    : ['\w\+<', '>'], 'input'   : ['g'], 'nesting' : 1, 'regex'   : 1, }, { 'buns'    : ['#{', '}'], 'input'   : ['n'], 'nesting' : 1 } ] ]])


end
return C
