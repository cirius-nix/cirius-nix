{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  fishCfg = config.${namespace}.development.cli-utils.fish;
  cfg = config.${namespace}.development.term;
in
{
  options.${namespace}.development.term = {
    enable = mkEnableOption "term";
    main = lib.${namespace}.mkEnumOption [
      "kitty"
      "weztem"
    ] "kitty" "Main terminal for internal used";
  };

  config = mkIf cfg.enable {
    ${namespace} = lib.optionalAttrs pkgs.stdenv.isLinux {
      desktop-environment.hyprland = {
        events.onEmptyWorkspaces = {
          "1" = [ "$term" ];
        };
        variables = {
          term = lib.getExe pkgs.kitty;
        };
        shortcuts = [
          "$mainMod, RETURN, exec, $term"
        ];
      };
    };

    programs = {
      starship = {
        inherit (cfg) enable;
        enableFishIntegration = fishCfg.enable;
        settings = { };
      };

      kitty = {
        enable = true;
        shellIntegration.enableFishIntegration = true;
        # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
        themeFile = "Catppuccin-Macchiato";
        extraConfig = builtins.readFile ./assets/kitty/extra.conf;
        settings =
          {
            font_family = "Cascadia Mono NF";
            tab_bar_edge = "top";
            tab_bar_style = "slant";
            tab_bar_align = "center";
            background_opacity = 0.9;
            background_blur = 20;
            enabled_layouts = "splits:split_axis=horizontal,stack";
          }
          // lib.optionalAttrs pkgs.stdenv.isDarwin {
            font_size = "13.0";
            shell = "${pkgs.fish}/bin/fish --login --interactive";
            macos_option_as_alt = "both";
            macos_custom_beam_cursor = "yes";
            macos_thicken_font = 0;
            macos_colorspace = "displayp3";
          };

        keybindings =
          {
            "ctrl+a>o" = "toggle_layout stack";
            "ctrl+shift+t" = "new_tab_with_cwd";
            "ctrl+a>shift+q" = "close_tab";

            "ctrl+a>w" = "start_resizing_window";
            "ctrl+shift+v" = "paste_from_clipboard";
            "ctrl+shift+s" = "paste_from_selection";
            "ctrl+shift+c" = "copy_to_clipboard";
            "alt+v" = "paste_from_clipboard";
            "alt+c" = "copy_to_clipboard";
            "ctrl+a>x" = "launch --location=hsplit --cwd=current";
            "ctrl+a>v" = "launch --location=vsplit --cwd=current";
            "ctrl+a>q" = "close_window";
            "ctrl+a>1" = "first_window";
            "ctrl+a>2" = "second_window";
            "ctrl+a>3" = "third_window";
            "ctrl+a>4" = "fourth_window";
            "ctrl+a>5" = "fifth_window";
            "ctrl+a>6" = "sixth_window";
            "ctrl+a>7" = "seventh_window";
            "ctrl+a>8" = "eighth_window";
            "ctrl+a>9" = "ninth_window";
            "ctrl+a>h" = "neighboring_window left";
            "ctrl+a>j" = "neighboring_window down";
            "ctrl+a>k" = "neighboring_window up";
            "ctrl+a>l" = "neighboring_window right";
            "ctrl+left" = "neighboring_window left";
            "ctrl+down" = "neighboring_window down";
            "ctrl+up" = "neighboring_window up";
            "ctrl+right" = "neighboring_window right";
            "shift+up" = "move_window up";
            "shift+left" = "move_window left";
            "shift+down" = "move_window down";
            "shift+right" = "move_window right";
            "ctrl+a>r" = "layout_action rotate";
            "ctrl+shift+plus" = "change_font_size all +2.0";
            "ctrl+shift+equal" = "change_font_size all +2.0";
            "ctrl+shift+minus" = "change_font_size all -2.0";
            "ctrl+shift+kp_subtract" = "change_font_size all -2.0";
            "ctrl+shift+backspace" = "change_font_size all 0";
          }
          // lib.optionalAttrs pkgs.stdenv.isLinux {
            "alt+1" = "goto_tab 1";
            "alt+2" = "goto_tab 2";
            "alt+3" = "goto_tab 3";
            "alt+4" = "goto_tab 4";
            "alt+5" = "goto_tab 5";
            "alt+6" = "goto_tab 6";
            "alt+7" = "goto_tab 7";
            "alt+8" = "goto_tab 8";
            "alt+9" = "goto_tab 9";
          }
          // lib.optionalAttrs pkgs.stdenv.isDarwin {
            "cmd+1" = "goto_tab 1";
            "cmd+2" = "goto_tab 2";
            "cmd+3" = "goto_tab 3";
            "cmd+4" = "goto_tab 4";
            "cmd+5" = "goto_tab 5";
            "cmd+6" = "goto_tab 6";
            "cmd+7" = "goto_tab 7";
            "cmd+8" = "goto_tab 8";
            "cmd+9" = "goto_tab 9";
          };
      };
    };
  };
}
