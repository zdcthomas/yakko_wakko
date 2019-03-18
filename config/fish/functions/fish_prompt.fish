set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red
set __fish_git_prompt_show_informative_status

# Status Chars
#set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '⤵'
set __fish_git_prompt_char_upstream_ahead '⤴'

function fish_prompt
  set -g fish_prompt_pwd_dir_length 0
  set_color normal
  
  set last_status $status
  
  if not set -q __git_cb
    set __git_cb ":"(set_color green)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)""
  end


  echo -n (prompt_pwd)
  #echo -n $__git_cb
  echo -n (__fish_git_prompt)
  fishy
end

function fishy
  set_color blue 
  echo -n ' >'
  set_color red
  echo -n '<'
  set_color green
  echo -n '>'
end
