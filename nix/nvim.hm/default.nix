{...}: 
{
  home = {

    file = {
      ".config/nvim/" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/yakko_wakko/config/nvim";
      };
    };
    packages = with pkgs; [
      neovim
      fzf
      zathura
      boxes
      fd
      jq
      ripgrep
      silver-searcher
      statix
      pavucontrol
      cava
      imv
      nixpkgs-fmt
      stylua
      lua-language-server
      prettierd
      eslint_d
      rust-analyzer-nightly
      yamlfmt
      marksman
      nixd
      xdg-utils
      discord
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
      ])
    ];

  };
}
