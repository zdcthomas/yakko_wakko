set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'


function fish_prompt
  set -g fish_prompt_pwd_dir_length 0
  set_color blue
  
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
