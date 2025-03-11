{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkIf;
  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "gnome") {
    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];
    services = {
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        displayManager.gdm.wayland = true;
        desktopManager = {
          gnome = {
            enable = true;
            extraGSettingsOverridePackages = [ pkgs.mutter ];
            extraGSettingsOverrides = ''
              [org.gnome.mutter]
              experimental-features=['scale-monitor-framebuffer']
            '';
          };
        };
        xkb = {
          layout = "us";
          variant = "";
        };
      };
      printing.enable = false;
    };
  };
}
