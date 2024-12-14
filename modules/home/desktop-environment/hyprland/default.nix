{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.desktop-environment.hyprland;
in
{
  options.cirius.desktop-environment.hyprland = {
    enable = mkEnableOption "Hyprland";
    appendConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
    prependConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        xwaylandvideobridge
        grim
        slurp
      ];
      sessionVariables = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        WLR_DRM_NO_ATOMIC = "1";
        XDG_SESSION_TYPE = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
      };
    };
  };
}
