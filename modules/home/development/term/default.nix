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
      themeFile = "Atom";
      settings = {
        font_family = "Cascadia Mono NF";
      };
    };
    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./assets/wezterm/wezterm.lua;
    };
  };
}
