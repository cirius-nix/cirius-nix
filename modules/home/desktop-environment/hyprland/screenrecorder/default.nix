{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
lib.optionalAttrs pkgs.stdenv.isLinux (
  let
    inherit (lib) mkIf;
    deCfg = config.${namespace}.desktop-environment;
  in
  {
    config = mkIf (deCfg.kind == "hyprland") {
      home.packages = with pkgs; [
        kdePackages.xwaylandvideobridge
      ];
      wayland.windowManager.hyprland = {
        settings = {
          windowrulev2 = [
            "nofocus, class:^(xwaylandvideobridge)$"
            "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
            "noanim,class:^(xwaylandvideobridge)$"
            "noinitialfocus,class:^(xwaylandvideobridge)$"
            "maxsize 1 1,class:^(xwaylandvideobridge)$"
            "noblur,class:^(xwaylandvideobridge)$"
          ];
        };
      };
    };
  }
)
