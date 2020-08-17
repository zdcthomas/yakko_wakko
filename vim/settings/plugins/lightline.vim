let g:lightline_medium_win = 80
let g:lightline_small_win = 55

" materia
" PaperColor
" Tomorrow_Night_Eighties
" seoul256
let g:lightline = {
    \ 'colorscheme': 'PaperColor',
    \ 'active': {
    \   'left': [ ['mode', 'paste', 'test'], ['filename',  'githunks', 'readonly', 'cocstatus'] ],
    \   'right': [ [ 'lineinfo' ], [ 'percent' ],  ['filetype', 'gitbranch'] ]
    \   },
    \ 'component_function': {
    \   'githunks': 'LightlineGitGutter',
    \   'filename': 'AbbrevLightLineFileName',
    \   'readonly': 'LightlineReadonly',
    \   'gitbranch': 'GetGitBranch',
    \   'diagnostic': 'StatusDiagnostic',
    \   'cocstatus': 'coc#status',
    \   'filetype': 'LightlineFileType',
    \   'test': 'LLTEST'
    \   },
    \ 'component': {
    \   'filename': '%<%{LightLineFilename()}',
    \   },
    \ }

function! LightlineFileType()
  if winwidth(0) < g:lightline_medium_win
    return ""
  endif
  return &filetype
endfunction

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' ') . ' ' . get(g:, 'coc_status', '')
endfunction

augroup LightLineStuff
  autocmd!
  autocmd FocusGained * let g:light_line_git_branch = GitBranch()
augroup END

function! LightlineGitGutter()
  if winwidth(0) < g:lightline_medium_win
    return ""
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction

function! GetGitBranch()
  if winwidth(0) < g:lightline_medium_win
    return ""
  endif
  if exists('g:light_line_git_branch')
    return g:light_line_git_branch
  else
    ''
  endif
endfunction

function! BaseFileName()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

function! AbbrevLightLineFileName() abort
  let base_file_name = BaseFileName()
  let win_width = winwidth(0)
  if (win_width - 40) < strlen(base_file_name)
    let name = ""
    let subs = split(expand('%'), "/") 
    let i = 1
    for s in subs
      let parent = name
      if  i == len(subs)
        let name = parent . '/' . s
      elseif i == 1
        let name = s
      else
        let name = parent . '/' . strpart(s, 0, 2)
      endif
      let i += 1
    endfor
    return name
  else
    return base_file_name
  endif
endfunction

function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction

