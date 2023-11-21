{
  pkgs,
  config,
  ...
}: let
  hex = color: ("#" + config.colorScheme.colors.${color});
in {
  programs.alacritty = {
    enable = true;

    settings = {
      key_bindings = [
        {
          key = "Plus";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }
      ];
      window = {
        title = "Terminal";
        opacity = 0.8;
        dimensions = {
          lines = 75;
          columns = 100;
        };
      };

      font = {
        normal.family = "PragmataPro Mono Liga";
        size = 11.0;
      };
      colors = {
        # Default colors
        primary = {
          background = hex "base00";
          foreground = hex "base05";
        };

        # Colors the cursor will use if `custom_cursor_colors` is true
        cursor = {
          text = hex "base00";
          cursor = hex "base0A";
        };

        selection = {
          text = hex "base07";
          background = hex "base0D";
        };

        # Normal colors
        normal = {
          black = hex "base00";
          red = hex "base08";
          green = hex "base0B";
          yellow = hex "base0A";
          blue = hex "base0D";
          magenta = hex "base0E";
          cyan = hex "base0C";
          white = hex "base07";
        };
      };
    };
  };
}
