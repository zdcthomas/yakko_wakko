{ config, lib, ... }:
let cfg = config.custom.hm.claude;
in {
  options = {
    custom.hm.claude = {
      enable = lib.mkEnableOption "Claude Code skills tracked in this repo";
    };
  };

  config = lib.mkIf cfg.enable {
    # Out-of-store symlink, not a copy: editing the skill takes effect at once,
    # with no rebuild. Same reason nvim and zk are wired this way.
    #
    # Skills here must stay generic. This repo is public, so no hostnames, no
    # paths into private repos, and no wiki content -- only the protocol and
    # the script, both of which discover the wiki at runtime.
    home.file.".claude/skills/agent-wiki" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/yakko_wakko/config/claude/skills/agent-wiki";
    };

    home.file.".claude/skills/kanboard" = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/yakko_wakko/config/claude/skills/kanboard";
    };
  };
}
