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
      # unstable.tmux
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
        undercurl = ''
          set -ga terminal-overrides ",tmux-256color:Tc"
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
          set -as terminal-overrides ',*:Setulc=\E[58::2::::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
          set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
          set -sg terminal-overrides "*:RGB"
        '';
        colorschemes = {
          new_gb = ''
            # Tmux status line with gruvbox dark colors.
            # Palette: https://github.com/morhetz/gruvbox#palette

            # Status bar colors.
            set-option -g status-fg colour223 # fg1
            set-option -g status-bg colour235 # bg0

            # Window list colors.
            set-window-option -g window-status-style fg=colour246,bg=colour239
            set-window-option -g window-status-current-style fg=colour235,bg=colour246,bright
            set-window-option -g window-status-activity-style fg=colour250,bg=colour241

            # Pane divider colors.
            set-option -g pane-border-style fg=colour239 # bg2
            set-option -g pane-border-style bg=colour235 # bg0
            set-option -g pane-active-border-style fg=colour142 # brightgreen
            set-option -g pane-active-border-style bg=colour235 # bg0

            # Command-line messages colors.
            set-option -g message-style fg=colour223 # fg1
            set-option -g message-style bg=colour235 # bg0
            set-option -g message-style bright

            # prompt to display when tmux prefix key is pressed
            set-option -g @mode_indicator_prefix_prompt ' WAIT  '

            # prompt to display when tmux is in copy mode
            set-option -g @mode_indicator_copy_prompt ' COPY 󰆏 '

            # prompt to display when tmux has synchronized panes
            set-option -g @mode_indicator_sync_prompt ' SYNC  '

            # prompt to display when tmux is in normal mode
            set-option -g @mode_indicator_empty_prompt '  I󰣐   '
            # IMPORTANT: if you can't see some characters, download some nerd font


            # set Tmux Mode Indicator styles to Gruvbox colors

            # style values for prefix prompt
            set-option -g @mode_indicator_prefix_mode_style 'bg=#d65d0e,fg=colour235'

            # style values for copy prompt
            set-option -g @mode_indicator_copy_mode_style 'bg=#d79921,fg=colour235'

            # style values for sync prompt
            set-option -g @mode_indicator_sync_mode_style 'bg=#cc241d,fg=colour235'

            # style values for empty prompt
            set-option -g @mode_indicator_empty_mode_style 'bg=colour246,fg=colour235'

            # Set left and right sections.
            set-option -g status-left-length 20
            set-option -g status-left "#[fg=colour235,bg=colour246] #S "
            set-option -g status-right '#{tmux_mode_indicator}'

            # Set format of items in window list.
            setw -g window-status-format " #I:#W#F "
            setw -g window-status-current-format " #I:#W#F "

            # Set alignment of windows list.
            set-option -g status-justify centre

            # Identify activity in non-current windows.
            set-window-option -g monitor-activity on
            set-option -g visual-activity on
          '';
          gruvbox = ''
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

            set -g status-justify "centre"
            set -g status-position "top"
          '';
          tokyo-storm = ''
            #!/usr/bin/env bash

            # TokyoNight colors for Tmux

            set -g mode-style "fg=#7aa2f7,bg=#3b4261"

            set -g message-style "fg=#7aa2f7,bg=#3b4261"
            set -g message-command-style "fg=#7aa2f7,bg=#3b4261"

            set -g pane-border-style "fg=#3b4261"
            set -g pane-active-border-style "fg=#7aa2f7"

            set -g status "on"
            set -g status-justify "left"
            set -g status-position "top"

            set -g status-style "fg=#7aa2f7,bg=#1f2335"

            set -g status-left-length "100"
            set -g status-right-length "100"

            set -g status-left-style NONE
            set -g status-right-style NONE

            set -g status-left "#[fg=#1d202f,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1f2335,nobold,nounderscore,noitalics]"
            set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1d202f,bg=#7aa2f7,bold] #h "
            if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
              set -g status-right "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#1f2335] #{prefix_highlight} #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261] %Y-%m-%d  %H:%M #[fg=#7aa2f7,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1d202f,bg=#7aa2f7,bold] #h "
            }

            setw -g window-status-activity-style "underscore,fg=#a9b1d6,bg=#1f2335"
            setw -g window-status-separator ""
            setw -g window-status-style "NONE,fg=#a9b1d6,bg=#1f2335"
            setw -g window-status-format "#[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1f2335,bg=#1f2335,nobold,nounderscore,noitalics]"
            setw -g window-status-current-format "#[fg=#1f2335,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#7aa2f7,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1f2335,nobold,nounderscore,noitalics]"

            # tmux-plugins/tmux-prefix-highlight support
            set -g @prefix_highlight_output_prefix "#[fg=#e0af68]#[bg=#1f2335]#[fg=#1f2335]#[bg=#e0af68]"
            set -g @prefix_highlight_output_suffix ""
          '';
        };
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
        shell = "${pkgs.zsh}/bin/zsh";
        sensibleOnTop = false;
        historyLimit = 200000;
        customPaneNavigationAndResize = true;
        package = pkgs.unstable.tmux;
        plugins = with pkgs; [
          tmuxPlugins.tmux-fzf
          {
            plugin = tmuxPlugins.power-theme;
            # TODO: <25-04-24, zdcthomas> set to some config.custom.hm.browser value
            extraConfig = ''
              set -g @tmux_power_theme 'everforest'
            '';
          }
          {
            plugin = fzf-tmux-url;
            # TODO: <25-04-24, zdcthomas> set to some config.custom.hm.browser value
            extraConfig = ''
              set -g @fzf-url-open "firefox"
            '';
          }
          # {
          #   plugin = tmuxPlugins.jump;
          #   extraConfig = ''
          #
          #   '';
          # }
        ];
        keyMode = "vi";
        # terminal = "screen-256color";
        aggressiveResize = true;
        escapeTime = 0;
        extraConfig = ''

          set -g default-terminal "tmux-256color"
          ${undercurl}
          set -g status-position "top"

          set-option -g focus-events on

          bind M-l split-window -h -c "#{pane_current_path}"
          bind M-h split-window -hb -c "#{pane_current_path}"

          # PREFIX j: Create a new horizontal pane.
          bind M-j split-window -v -c "#{pane_current_path}"
          bind M-k split-window -vb -c "#{pane_current_path}"

          # unbind-key -T copy-mode-vi MouseDragEnd1Pane

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
