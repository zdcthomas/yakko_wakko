{
  config,
  inputs,
  pkgs,
  username,
  ...
}: let
  management_scripts = import ../../nix_management_scripts_pkgs.nix {
    pkgs = pkgs;
    homeDirectory = config.home.homeDirectory;
  };
in {
  imports = [
    ../../modules/home
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-soft;

  custom.hm = {
    alacritty.enable = true;
    bash.enable = true;
    aerospace.enable = true;
    nushell.enable = true;
    cli.enable = true;
    fish.enable = true;
    font.enable = true;
    git.enable = true;
    hammerspoon.enable = true;
    kitty.enable = true;
    nix.enable = true;
    nvim.enable = true;
    ssh.enable = true;
    # starship.enable = true;
    tmux.enable = true;
    wezterm = {
      enable = true;
      font-size = "13";
    };
    zellij.enable = true;
    zsh.enable = true;
  };
  home = {
    username = username;
    homeDirectory = "/Users/" + username;
    stateVersion = "22.05";
    sessionVariables = {
      HOMEBREW_PREFIX = "/opt/homebrew";
      HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
      HOMEBREW_REPOSITORY = "/opt/homebrew";
      PATH = "$PATH:$HOME/.cargo/bin/:$HOME/.local/share/bob/nvim-bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$HOME/bin:$HOME/.npm-global/bin";
    };

    packages = with pkgs;
      [
        nurl
        deno
        nix-init
        font-awesome_5
        du-dust
        gnumake
        go
        graphviz
        lua
        nodejs
        statix
        weechat
        zk
        dmux
        # go
        rustup
        (
          nerdfonts.override {
            fonts = [
              "Iosevka"
              # "JetBrains"
            ];
          }
        )
        hurl_2
        awscli2
        git-remote-codecommit
      ]
      ++ management_scripts;
  };
}
