
colorscheme gruvbox

function! SourceFile(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction

call SourceFile("~/.vim/settings/settings.vim")
call SourceFile("~/.vim/settings/mappings.vim")
call SourceFile("~/.vim/settings/commands.vim")
call SourceFile("~/.vim/settings/plugins.vim")
if has('nvim')
  call SourceFile("~/.vim/settings/nvim_settings.vim")
endif
