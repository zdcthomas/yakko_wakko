{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.hm.tmux;
in {
  options = {
    custom.hm.tmux = {
      enable = lib.mkEnableOption "Enable custom tmux";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tmuxPlugins.tmux-fzf
      tmux
      dmux
    ];
    home.file = {
      ".config/dmux/dmux.conf.toml".source = ../../../../config/dmux/dmux.conf.toml;
    };

    programs = {
      tmux = let
        copy =
          if pkgs.stdenv.isLinux
          then "${pkgs.wl-clipboard}/bin/wl-copy"
          else "pbcopy";
        fzf-tmux-url = pkgs.tmuxPlugins.mkTmuxPlugin {
          pluginName = "fzf-tmux-url";
          rtpFilePath = "fzf-url.tmux";
          version = "new";
          src = pkgs.fetchFromGitHub {
            owner = "wfxr";
            repo = "tmux-fzf-url";
            rev = "28ed7ce3c73a328d8463d4f4aaa6ccb851e520fa";
            sha256 = "sha256-tl0SjG/CeolrN7OIHj6MgkB9lFmFgEuJevsSuwVs+78=";
          };
        };
      in {
        enable = true;
        /*
        extraConfig = (builtins.readFile ./tmux.conf);
        */
        /**/
        # shell = "${pkgs.zsh}/bin/zsh";
        sensibleOnTop = false;
        historyLimit = 200000;
        customPaneNavigationAndResize = true;
        plugins = with pkgs; [
          tmuxPlugins.tmux-fzf
          {
            plugin = fzf-tmux-url;
            # TODO: <25-04-24, zdcthomas> set to some config.custom.hm.browser value
            extraConfig = ''
              set -g @fzf-url-open "firefox"
            '';
          }
          {
            plugin = tmuxPlugins.tmux-thumbs;
            extraConfig = ''
              set -g @thumbs-command 'echo -n {} | ${copy}'
            '';
          }
        ];
        keyMode = "vi";
        terminal = "$TERM";
        aggressiveResize = true;
        escapeTime = 0;
        extraConfig = ''
          # undercurl support
          set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

          set-option -g status "on"
          set -g status-justify centre
          set -g status-position top

          # default statusbar color
          set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

          # default window title colors
          set-window-option -g window-status-style fg=white # bg=yellow, fg=bg1

          # default window with an activity alert
          # set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

          # set-window-option -g window-active-style bg=colour236 # bg=bg1, fg=fg3
          # set-window-option -g window-style bg=default

          # active window title colors
          set-window-option -g window-status-current-style bg=cyan,fg=default # fg=bg1

          # pane border
          set-option -g pane-active-border-style fg=red
          set-option -g pane-border-style fg=colour6

          # message infos
          set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

          # writing commands inactive
          set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

          # pane number display
          # set-option -g display-panes-active-colour colour250 #fg2
          # set-option -g display-panes-colour colour237 #bg1

          # clock
          set-window-option -g clock-mode-colour colour109 #blue

          # bell
          set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

          bind M-l split-window -h -c "#{pane_current_path}"
          bind M-h split-window -hb -c "#{pane_current_path}"

          # PREFIX j: Create a new horizontal pane.
          bind M-j split-window -v -c "#{pane_current_path}"
          bind M-k split-window -vb -c "#{pane_current_path}"

          unbind-key -T copy-mode-vi MouseDragEnd1Pane

          # Scroll 3 lines at a time instead of default 5; don't extend dragged selections.
          bind-key -T copy-mode-vi WheelUpPane select-pane\; send-keys -t'{mouse}' -X clear-selection\; send-keys -t'{mouse}' -X -N 3 scroll-up
          bind-key -T copy-mode-vi WheelDownPane select-pane\; send-keys -t'{mouse}' -X clear-selection\; send-keys -t'{mouse}' -X -N 3 scroll-down

          # Don't exit copy mode on double or triple click.
          bind-key -T copy-mode-vi DoubleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-word"
          bind-key -T copy-mode-vi TripleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-line"

          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${copy}'
          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi r send-keys -X rectangle-toggle

          # Mouse
          set -g mouse on
        '';
      };
    };
  };
}
