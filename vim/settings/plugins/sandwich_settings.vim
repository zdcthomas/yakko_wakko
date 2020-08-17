let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

nmap ys <Plug>(operator-sandwich-add)
onoremap <SID>line :normal! ^vg_<CR>
nmap <silent> yss <Plug>(operator-sandwich-add)<SID>line
onoremap <SID>gul g_
nmap yS ys<SID>gul

nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap dss <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap css <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

xmap S <Plug>(operator-sandwich-add)

xmap is <Plug>(textobj-sandwich-query-i)
xmap as <Plug>(textobj-sandwich-query-a)
omap is <Plug>(textobj-sandwich-query-i)
omap as <Plug>(textobj-sandwich-query-a)

xmap iss <Plug>(textobj-sandwich-auto-i)
xmap ass <Plug>(textobj-sandwich-auto-a)
omap iss <Plug>(textobj-sandwich-auto-i)
omap ass <Plug>(textobj-sandwich-auto-a)

xmap im <Plug>(textobj-sandwich-literal-query-i)
xmap am <Plug>(textobj-sandwich-literal-query-a)
omap im <Plug>(textobj-sandwich-literal-query-i)
omap am <Plug>(textobj-sandwich-literal-query-a)

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

let g:sandwich#magicchar#f#patterns = [
\   {
\     'header' : '\h*\:*\h*',
\     'bra'    : '(',
\     'ket'    : ')',
\     'footer' : '',
\   },
\ ] 

" Default recipes
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
    \   {
    \     'buns'    : ['%{', '}'],
    \     'input'   : ['m'],
    \     'nesting' : 1
    \   },
    \   {
    \     'buns'    : 'StructInput()',
    \     'kind'    : ['add', 'replace', 'delete'],
    \     'action'  : ['add'],
    \     'input'   : ['s'],
    \     'listexpr': 1,
    \     'nesting' : 1
    \   },
    \   {
    \     'buns'    : 'GenericInput()',
    \     'kind'    : ['add', 'replace'],
    \     'action'  : ['add'],
    \     'input'   : ['g'],
    \     'listexpr': 1,
    \     'nesting' : 1
    \   },
    \   {
    \     'buns'    : ['\w\+<', '>'],
    \     'input'   : ['g'],
    \     'nesting' : 1,
    \     'regex'   : 1,
    \   },
    \   {
    \     'buns'    : ['#{', '}'],
    \     'input'   : ['n'],
    \     'nesting' : 1
    \   },
    \ ]
" n = iNterpolate
" m = Map
" g = Generic

