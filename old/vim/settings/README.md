# Neovim

## Plugins

In general I'm fairly weary of adding new plugins, but if the addition of a
plugin does impact startup time or repsonsiveness then I'm very comfortable
adding/writing something I feel will be useful.

I have a couple of hot take substitutions for common plugins that are probably
worth noting

* [sandwich](#Sideways.vim) NOT
  [Surround](https://github.com/tpope/vim-surround). I started using this
  because of the better function surround support but stayed for the
  customization
* [Dirvish](#Dirvish) NOT [NerdTree](https://github.com/preservim/nerdtree).
  For my workflow, I really prefer the fast, single window NETRW style of file
  explorer on the fairly rare occasions I use it. Most of the time I'm using
  [FZF](#FZF)
* [GitGuter](#GitGutter) NOT [FUGITIVE](https://github.com/tpope/vim-fugitive).
  Fugitive just feels way to bloated and doesn't work for me *a lot* of the
  time.
* [My fish plugin](#VISH) NOT [The standard fish
  plugin](https://github.com/dag/vim-fish). The standard fish plugin is fairly
  dead and super super slow sometimes.
* [Community Gruvbox](#Grubox) NOT [Morhetz's
  Gruvbox](https://github.com/morhetz/gruvbox). This is less and less of a hot
  take, but the community gruvbox is faster and more maintained. Still by far
  the slowest plugin.
* [lightline](#LighLine) NOT
  [Airline](https://github.com/vim-airline/vim-airline). Airline is a lot
  slower and in my opinion more poorly designed. With lightline you build your
  own components to interact with stuff the way you want. And I use it for my
  fishy.

Below are just plugins of note in my setup

### Vim-Plug

[Vim-Plug](https://github.com/junegunn/vim-plug) is the plugin manager. The
magic sauce here is

```vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
```

Which installs it for you if you don't have it.

#### runtime

The other cool thing about Plug is that it manages what is and isn't in the
runtimepath of vim. I use this to conditionally add configuration to my plugins
based on whether or not their being used.

```vim
if &runtimepath =~ 'gruvbox'
  ...(do some stuff)
endif

```

### Swap

[Swap](https://github.com/machakann/vim-swap) is a plugin to move around the
elements of a character delineated list. This could be arguments to a function,
elements in a collection, file imports, you name it! I think the most used part
of it is the sorting function that sorts a list automatically.

### leader-mapper

I use leader mapper almost exclusively to to create nice pneumonic menus to
call less-used functions and commands, e.g languag server commands through Coc

### easy-align

This is a super powerful plugin but I have not yet learned all of it's
features. Primarily I use `ga(text-object)(char)` to align every instance of a
given char with a given ext object. The
[README](https://github.com/junegunn/vim-easy-align) has some very good demos

### vim-sandwich

This supplants the more usually used
[Surround](https://github.com/tpope/vim-surround) plugin by
[Tpope](https://github.com/tpope). Surround is a lot less customizable and has
worse custom head and foot support for the surround you might want to use.

### Coc

[Coc](https://github.com/neoclide/coc.nvim) the beefiest of plugins, this is my
completion library of choice. It gives me a bunch of language server stuff as
well as diagnostics, code actions, code lens stuff, all sorts of things. My
biggest complaint about it is ideological as it uses node, and honestly it's
pretty fast.
