{ config, pkgs, lib, inputs, ... }:
let cfg = config.custom.hm.zellij;
in {
  options = {
    custom.hm.zellij = { enable = lib.mkEnableOption "Enable custom zellij"; };
  };
  config = lib.mkIf cfg.enable {
    home.sessionVariables = { ZELLIJ_AUTO_ATTACH = "true"; };
    home = {
      file = {
        ".config/zellij/" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.home.homeDirectory}/yakko_wakko/config/zellij";
        };
      };
      packages = with pkgs; [ zellij ];
    };

    # programs.zellij = {
    #   enable = true;
    #   settings = {
    #     theme = "gruvbox-dark";
    #     copy_command = "${pkgs.wl-clipboard}/bin/wl-copy";
    #
    #     default_mode = "locked";
    #
    #     pane_frames = false;
    #     on_force_close = "detach";
    #     ui = {
    #       pane_frames = {
    #         hide_session_name = true;
    #         rounded_corners = true;
    #       };
    #     };
    #   };
    # };
  };
}
