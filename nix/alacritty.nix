{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        title = "Terminal";
        opacity = 0.8;
        dimensions = {
          lines = 75;
          columns = 100;
        };
      };

      font = {
        normal.family = "FiraCode Nerd Font";
        size = 11.0;
      };
      colors = {
        # Default colors
        primary = {
          background = "#061923";
          foreground = "#e5c49e";
        };

        # Colors the cursor will use if `custom_cursor_colors` is true
        cursor = {
          text = "#061822";
          cursor = "#feaf3c";
        };

        selection = {
          text = "#ffe9d7";
          background = "#265b75";
        };

        # Normal colors
        normal = {
          black = "#1d485f";
          red = "#db662d";
          green = "#008eab";
          yellow = "#feaf3c";
          blue = "#255a62";
          magenta = "#77dbf4";
          cyan = "#5fb1c2";
          white = "#e5c49e";
        };

        # Bright colors
        bright = {
          black = "#545d65";
          red = "#dd998a";
          green = "#739da8";
          yellow = "#fedaae";
          blue = "#0bc7e3";
          magenta = "#c6e8f1";
          cyan = "#97b9c0";
          white = "#ffe9d7";
        };
      };
      # colors = {
      #   primary = {
      #     background = "0x000000";
      #     foreground = "0xEBEBEB";
      #   };
      #   cursor = {
      #     text = "0xFF261E";
      #     cursor = "0xFF261E";
      #   };
      #   normal = {
      #     black = "0x0D0D0D";
      #     red = "0xFF301B";
      #     green = "0xA0E521";
      #     yellow = "0xFFC620";
      #     blue = "0x178AD1";
      #     magenta = "0x9f7df5";
      #     cyan = "0x21DEEF";
      #     white = "0xEBEBEB";
      #   };
      #   bright = {
      #     black = "0x6D7070";
      #     red = "0xFF4352";
      #     green = "0xB8E466";
      #     yellow = "0xFFD750";
      #     blue = "0x1BA6FA";
      #     magenta = "0xB978EA";
      #     cyan = "0x73FBF1";
      #     white = "0xFEFEF8";
      #   };
      # };
    };
  };
}
