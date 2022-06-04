# Welcome!!
  This directory is my whole [NeoVim](https://neovim.io/) config! I really love
  toying with my config and tinkering. My editing-env is the garden that I like
  to trim, and I'd love to show you around!

<!-- # A tour through the garden! -->

## Starting out at the gate
  My [./init.lua](init.lua) is the entry point for my nvim config. It used to
  contain a lot of settings and commands, but now it's almost entirely
  requiring other files that have more focused responsibilities. Those files
  are all in the [./lua/](lua) directory. `:h lua-require` to learn more!

## But what are all those weird other directories?
  I'm glad you asked! Vim and NeoVim have a series of files and directories
  that they source for different parts of the startup process. `:h runtimpath`

### after/
  Generally used to override all other configurations, as it is run _after_
  other source paths

### compiler/
  (Neo)Vim has first class integration with compilers and make commands. This
  directory sets up new compilers/commands that (Neo)Vim can then access via
  various commands.

  I just use it to let (Neo)Vim use credo for
  [Elixir](https://elixir-lang.org/) development!

### ftplugin/
  These files are used to configure how (Neo)Vim is configured when editing
  those filetypes. These are simply more convenient ways to define filetype
  specific configs, but I might move them over to autocmds since they're so
  nice since [nvim 0.7](https://neovim.io/news/2022/04) became stable!
  
  These files get loaded every time a file with that filetype is opened, so be
  careful to not put anything that can't be called more than once, or is too
  slow in there.

### lua/
  `:h lua-require`
  This directory is not automatically loaded as part of the runtime path,
  however it is the place that the `require()` function in lua looks first.
  Because of this, it becomes a catchall location for all the primary
  configuration files written in lua, which is now all of them! :)

  Head over there and checkout the [README](./lua/README.md) to learn more!

### plugin/
  `:h add-global-plugin`
  This directory is usually used to add/create plugins across all filetypes. 
  Now thought, I only use it to store my 
  [packer compiled artifact](./plugin/packer_compiled.lua), which is generated automatically by 
  [packer](https://github.com/wbthomason/packer.nvim), the plugin manager I
  use.

### snippets/
  This is a directory I made myself for storing the .json, languae specific
  [vscode style snippets](https://code.visualstudio.com/api/language-extensions/snippet-guide)

