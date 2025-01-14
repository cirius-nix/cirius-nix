{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf getExe;

  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "hyprland") {
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "${getExe pkgs.openrgb-with-all-plugins} --startminimized --profile default"
        ];
      };
    };
  };
}
