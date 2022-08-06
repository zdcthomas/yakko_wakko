set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red
set __fish_git_prompt_show_informative_status

# Status Chars
#set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '⤵'
set __fish_git_prompt_char_upstream_ahead '⤴'

function fish_prompt
  set -l last_status $status
  set -g fish_prompt_pwd_dir_length 0
  set_color normal
  echo -n (prompt_pwd)
  echo -n (__fish_git_prompt)
  printf '\n| '
  status_fishy $last_status
end

function status_fishy
  if [ $argv[1] -ne 0 ]
    set_color red 
    echo -n '>'
    echo -n '<'
    set_color normal
    echo -n $argv[1]
    set_color red
    echo -n '>'
  else
    set_color cyan 
    echo -n '>'
    set_color red
    echo -n '<'
    set_color brgreen
    echo -n '> '
  end
end
