# Neovim lua

All files in here can be directly `require`'d from neovim lua but many aren't
meant to be, specifically the [plugins](#plugins) directory.

## Plugins

This is the directory monitored by Lazy and defines all the plugins and their
configurations. These are just data and none of the `config` fields in any of
the tables here run at all until `Lazy` decides that they should.

### A digression about best practices.

It's **very** important, if you want an editor config that doesn't become
unusable after every change to any plugin, to closely bind together
configuration, installation, and dependencies. Many people will simply specify
a list of plugins to install and then write their configurations in a file (or
collection of files) which is always evaluated. This means that:

- lazy-loading has to be abandoned almost entirely
- If a plugin is removed or it's spec changes, you will always get an error
- it's harder to find relevant configuration if you want to change something
- it's non atomic, which means that you have to remember to delete **both** the configuration **and** the plugin spec
- you don't have any guarantees that any given plugin doesn't depend on any other plugin

These are all bad, and are many of the reasons most people who structure their
configurations this way complain vociferously across the boards about how
Neovim is so unstable and their config is unmaintainable. It's not entirely
their fault though.

Long ago, in the days of yore, when plugins where just files on pastebin (and
for a while after but dramatic effect is cool), configuration was done through
global variables, e.g `let g:surround_insert_tail = "<++>"`. These are just
placing data in the global namespace, and therefore don't break when a plugin
isn't present or changes, it just does nothing. But nowadays, we require
modules from plugins to configure them, and that doesn't work if the module
isn't loaded.
