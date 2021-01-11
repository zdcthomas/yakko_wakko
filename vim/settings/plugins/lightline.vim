" materia
" PaperColor
" Tomorrow_Night_Eighties
" seoul256
let g:lightline = {
    \ 'colorscheme': 'PaperColor',
    \ 'active': {
    \   'left': [ ['mode_anim', 'paste'], ['filename',  'githunks', 'readonly', 'cocstatus', 'anim_default'] ],
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
    \   'anim_default': 'AnimateDefault',
    \   'mode_anim': 'AnimateMode'
    \   },
    \ 'component': {
    \   'lineinfo': '%3l:%-2v%<',
    \   },
    \ }
let s:lightline_large_win = 100
let s:lightline_medium_win = 80
let s:lightline_small_win = 55
let s:current_frame = 0
let s:waves = [ 
  \ '.~"~._.',
  \ '_.~"~._',
  \ '._.~"~.',
  \ '~._.~"~',
  \ '"~._.~"',
  \ '~"~._.~',
  \ '.~"~._.'
  \ ]

let s:fish = [ 
  \ ">      ",
  \ "'>     ",
  \ "('>    ",
  \ "(('>   ",
  \ "<(('>  ",
  \ "><(('> ",
  \ " ><(('>",
  \ "  ><(('",
  \ "   ><((",
  \ "    ><(",
  \ "     ><",
  \ "      >",
  \ "       ",
  \ ]

let s:wave_blocks = [
  \ "▁▂▃▄▅▆▇█",
  \ "▂▃▄▅▆▇█▇",
  \ "▃▄▅▆▇█▇▆",
  \ "▄▅▆▇█▇▆▅",
  \ "▅▆▇█▇▆▅▄",
  \ "▆▇█▇▆▅▄▃",
  \ "▇█▇▆▅▄▃▂",
  \ "█▇▆▅▄▃▂▁",
  \ "▇▆▅▄▃▂▁▂",
  \ "▆▅▄▃▂▁▂▃",
  \ "▅▄▃▂▁▂▃▄",
  \ "▄▃▂▁▂▃▄▅",
  \ "▃▂▁▂▃▄▅▆",
  \ "▂▁▂▃▄▅▆▇",
  \ '▁▂▃▄▅▆▇█',
  \ ]

let s:bun_bun = [
  \ "(•ㅅ•)",
  \ "(•ㅅ•)",
  \ "(•ㅅ•)",
  \ "(-ㅅ•)",
  \ "(-ㅅ•)",
  \ "(•ㅅ•)",
  \ "(•ㅅ•)",
  \ "(•ㅅ-)",
  \ "(•ㅅ-)",
  \ "(•ㅅ•)",
  \ "(•ㅅ•)",
  \ "(-ㅅ-)",
  \ "(-ㅅ-)",
  \ ]
let s:dance = [
  \  "\\(@.@)-",
  \  "-(@.@)/",
  \  "/(@.@)-",
  \  '-(@.@)\',
  \  "\\(-.-)-",
  \  "\\(@.@)/",
  \  "-(-.-)-",
  \  "\\(@.@)/",
  \ ]

let s:possible_anims = [
  \ s:dance,
  \ s:bun_bun,
  \ s:wave_blocks,
  \ s:waves,
  \ s:fish,
  \ ]

let s:normal = [
  \ 'NORMAL',
  \ ' ORMAL',
  \ 'N RMAL',
  \ 'NO MAL',
  \ 'NOR AL',
  \ 'NORM L',
  \ 'NORMA ',
  \ 'NORMAL',
  \ 'NORMA ',
  \ 'NORM L',
  \ 'NOR AL',
  \ 'NO MAL',
  \ 'N RMAL',
  \ ' ORMAL',
  \ ]

let s:mode_to_anim = {
  \ 'n': s:normal,
  \ 'i': s:dance,
  \ 'ic': s:dance,
  \ 'ix': s:dance,
  \ 'v': s:waves,
  \ 'V': s:wave_blocks,
  \ }

function! RandomFrom(list) abort
  let second = system("date +%S")
  let frames = 60 / len(a:list)
  let index = second / frames
  return a:list[index]
endfunction

let s:interval = 10
let s:default_animation = s:fish
" RandomFrom(s:possible_anims)

function! AnimateMode() abort
  let anim = get(s:mode_to_anim, mode(), [])
  if anim != []
    return DoAnim(anim)
  else
    return lightline#mode()
  endif
endfunction

function! AnimateDefault() abort
  if winwidth(0) < s:lightline_medium_win
    return ""
  endif
  return DoAnim(s:default_animation)
endfunction

function! DoAnim(animation) abort
  if s:current_frame >= (len(a:animation)  * s:interval)
    let s:current_frame = 0
  endif
  let s:current_frame = s:current_frame + 1
  return get(a:animation, s:current_frame / s:interval , a:animation[0])
endfunction

function! LightlineFileType()
  if winwidth(0) < s:lightline_large_win
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

function! LightlineGitGutter()
  if winwidth(0) < s:lightline_large_win
    return ""
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction

function! DirtyFile()
  if winwidth(0) < s:lightline_medium_win
    return ""
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  if l:added+ l:modified+ l:removed > 0
    return '*'
  else
    return ''
  endif
endfunction

function! GetGitBranch()
  if winwidth(0) < s:lightline_medium_win
    return ""
  endif
  if exists('s:light_line_git_branch')
    return s:light_line_git_branch
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
  if strlen(base_file_name) >= win_width * 0.4
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

augroup LightLineStuff
  autocmd!
  autocmd FocusGained * let s:light_line_git_branch = GitBranch()
augroup END
let s:light_line_git_branch = GitBranch()
