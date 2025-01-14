{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cirius.development.term;
in
{
  options.cirius.development.term = {
    enable = mkEnableOption "term";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableFishIntegration = true;
      themeFile = "Molokai";
      extraConfig = builtins.readFile ./assets/kitty/extra.conf;
      settings = {
        font_family = "Cascadia Mono NF";
        tab_bar_edge = "top";
        tab_bar_style = "slant";
        tab_bar_align = "center";
        background_opacity = 0.9;
        background_blur = 20;
        enabled_layouts = "splits:split_axis=horizontal,stack";
      };
      keybindings = {
        "ctrl+a>o" = "toggle_layout stack";

        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";
        "ctrl+shift+t" = "new_tab_with_cwd";
        "ctrl+a>shift+q" = "close_tab";

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
      };
    };
    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./assets/wezterm/wezterm.lua;
    };
  };
}
