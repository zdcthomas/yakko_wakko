{ config, modulesPath, pkgs, overlays, lib, ... }:

let
  management_scripts = import ./nix/nix_management_scripts_pkgs.nix { pkgs = pkgs; homeDirectory = config.home.homeDirectory; };
in
{
  imports = [
    ./nix/firefox.nix
  ];
  # manual.html.enable = true;
  nixpkgs.overlays = overlays;
  nixpkgs.config = {
    allowUnfree = true;
  };

  news.display = "show";

  nix = {

    checkConfig = true;
    # package = pkgs.nixVersions.unstable;

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      auto-optimise-store = true
      # assuming the builder has a faster internet connection
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';
  };

  home = {
    /*     enableNixpkgsReleaseCheck = true; */
    /*     enableDebugInfo = true; */
    /*     username = "zdcthomas"; */
    /*     homeDirectory = "/Users/zdcthomas"; */

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    /* stateVersion = "22.05"; */

    /* extraOutputsToInstall = [ "man" ]; */
    packages = with pkgs; [

      # bash
      bashInteractive
      bat
      boxes
      exa
      fd
      firefox
      fish
      font-awesome_5
      fzf
      gh
      git
      gnumake
      htop
      jq
      kitty
      neovim
      nix-init
      nurl
      pandoc
      ripgrep
      rustup
      sd
      silver-searcher
      skim
      statix
      tmux
      tmuxPlugins.tmux-fzf
      tree
      unzip
      weechat
      wget
      zip

      rnix-lsp
      stylua
      lua-language-server
      prettierd
      eslint_d
      # rust-analyzer-nightly
      yamlfmt
      marksman
      nixd

      (
        nerdfonts.override {
          fonts = [
            "Terminus"
            "FiraCode"
            "Meslo"
            "Monofur"
            "Iosevka"
          ];
        }
      )
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";


    /* symlink the config directory. I know this isn't the nix way, but it's
      * ridiculous to invent another layer of rconfiguration languages */
    file = {
      ".config/nvim/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/nvim";
      };

      ".config/zk/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/zk";
      };
      /* ".tmux.conf".source = ./tmux.conf; */
      ".config/dmux/dmux.conf.toml".source = ./config/dmux/dmux.conf.toml;
      ".boxes".source = ./config/boxes/.boxes;
    };


    sessionVariables = {
      /* TODO: Split these out into another module */
      MANPATH = "/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
      INFOPATH = "/opt/homebrew/share/info:${INFOPATH:-}";

      EDITOR = "nvim";
      DIFFPROG = "nvim -d";
      SKIM_DEFAULT_COMMAND = "fd --hidden --type f";
      /* Move these to fzf program config */
      FZF_ALT_C_COMMAND = "fd -t d";
      FZF_ALT_C_OPTS = "--preview 'tree -C {} | head -200'";
      FZF_CTRL_T_OPTS = "--preview '(bat {} || tree -C {}) 2> /dev/null | head -200'";
      FZF_DEFAULT_COMMAND = "fd --hidden --type f";
      FZF_DEFAULT_OPTS = "--height 40% --reverse --border=rounded";
      PATH = "$PATH:$HOME/.cargo/bin/:$HOME/bin";
    };

    sessionPath = [ "$HOME/.cargo/bin" ];

    shellAliases =
      {
        gco = "git switch";
        gs = "git status";
        n = "nvim";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        vimdiff = "nvim -d";
      };
  };
}
