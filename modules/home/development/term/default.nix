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
      settings = {
        font_family = "Cascadia Mono NF";
        tab_bar_edge = "top";
        tab_bar_style = "slant";
        tab_bar_align = "center";
        background_opacity = 0.9;
        background_blur = 20;
      };
    };
    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./assets/wezterm/wezterm.lua;
    };
  };
}
