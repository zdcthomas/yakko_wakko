# Welcome to my dotfiles!

[![Haiku for you](https://readme-typing-svg.demolab.com?font=Fira+Code&duration=4000&pause=500&center=true&vCenter=true&multiline=true&height=90&lines=Where+neat+hedges+sing;The+sheds+are+glorious+hues;and+the+yaks+tremble)](https://git.io/typing-svg)

---

![](http://ForTheBadge.com/images/badges/built-with-love.svg)
![](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)
![](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![](https://img.shields.io/badge/tmux-1BB91F?style=for-the-badge&logo=tmux&logoColor=white)

Please, look around! I really love working on my dotfiles but it's usually in
some type of flux so things might move from where I've documented them here.
Right now I'm using [Nix](https://nixos.org/) to manage all of my machines.
It's actually a pretty nice experience, but it is _definitely_ not for
everyone. Right now it's using an unstable feature that's very contentious
called [Flakes](https://nixos.wiki/wiki/Flakes). There's a lot of disagreement
in the community about whether or not this is a good idea, but I like them.

> What If I just want to see some normal config files?

Oh yeah! There's definitely some of those in the `./config/` directory. Some
may have handle-bar (`{{{like this}}}`) template stuff in them so I can apply
themes and stuff from nix, but ignore those and just put in some colors you
like!

Specifically if you're here to learn about [Neovim](./config/nvim/README.md),
that's entirely vanilla, non-nix, lua-based configuration.

## Before you fork!

Give
[this](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/#dotfiles-are-not-meant-to-be-forked)
a read. It's sums up my thoughts pretty well on forking dotfiles. Dotfiles are
the honed tools of your craft, they take time care and personal attention to set
up, get right, maintain, and remember! And while using someone else's tools is
fine at first, they should always just be a jumping off point.

---

## What's it look like?

Nowadays, this repo maintains configs for around four different machines,
so it looks very different for different machines, as well as when using
different themes.

### Nvim startup screen

![My Nvim Startup screen, showing a nice ascii bonsai tree](/images/nvim_startup.png)

The tree changes ages and then withers throughout the day! Entropy!

### The gruvbox days

This is one of my first theme-ings
![Show and Tell](/images/show_and_tell.png)

---

## RSS

Terminal RSS reading via [newsboat](https://newsboat.org/), managed by the
`custom.hm.rss` home-manager module in
[`nix/modules/home/rss/`](/nix/modules/home/rss/default.nix). Feeds are all
tagged `music` for now.

**Adding a feed:** add an entry to `programs.newsboat.urls` in
`nix/modules/home/rss/default.nix`, rebuild, then regenerate the OPML export:

```sh
newsboat -e > nix/modules/home/rss/feeds.opml
```

`feeds.opml` is a build artifact of the nix-managed url list — regenerate it,
don't hand-edit it. Import it elsewhere with `newsboat -i feeds.opml` or via
any reader's OPML import.

**Podcasts:** press `e` on an article to enqueue its enclosure, then run
`podboat` to download/play (saves to `~/Downloads/podcasts`). The macro `,v`
streams the current article's link straight into mpv without downloading.

**GUI:** setting `custom.hm.rss.gui.enable = true` installs
[NewsFlash](https://gitlab.com/news-flash/news_flash_gtk) for articles with
embedded players that a terminal can't render. NewsFlash keeps its own
database and does not stay in sync with newsboat — import `feeds.opml` into it
manually, and re-import after the feed list changes.

**No feed available** (checked 2026-08-09, nothing to subscribe to): Point of
Departure (static site), Perfect Sound Forever.

**Note:** The Quietus sits behind Cloudflare and rejects non-browser user
agents, so the module sets a Firefox `user-agent` string.

---

## What's the name?

Ever watch the [Animaniacs](https://www.youtube.com/watch?v=CWnWwN1z_UM)?

---

## This is a blog!

Take a look around! If you're interesting in NeoVim related stuff, head over to [neovim](/config/nvim/README.md)
