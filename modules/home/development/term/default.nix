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
    home.programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./assets/wezterm/wezterm.lua;
    };
  };
}
