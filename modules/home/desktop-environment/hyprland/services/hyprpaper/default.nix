{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    types
    mkOption
    ;
  inherit (lib.${namespace}) mkOpt;
  deCfg = config.${namespace}.desktop-environment;
  hyprCfg = deCfg.hyprland;
  cfg = hyprCfg.services.hyprpaper;

  enabled = pkgs.stdenv.isLinux && deCfg.kind == "hyprland" && cfg.enable;
in
{
  options.${namespace}.desktop-environment.hyprland.services.hyprpaper = {
    enable = mkEnableOption "Hyprpaper";
    wallpapers = mkOpt (types.listOf types.path) [ ] "Wallpapers to preload.";
    monitors = mkOption {
      description = "Monitors and their wallpapers";
      type =
        with types;
        listOf (submodule {
          options = {
            name = mkOption { type = str; };
            wallpaper = mkOption { type = path; };
          };
        });
    };
  };
  config = mkIf enabled {
    services = {
      hyprpaper = {
        enable = true;
        settings = {
          preload = map (w: builtins.toString w) cfg.wallpapers;
          wallpaper = map (monitor: "${monitor.name},${builtins.toString monitor.wallpaper}") cfg.monitors;
        };
      };
    };
  };
}
