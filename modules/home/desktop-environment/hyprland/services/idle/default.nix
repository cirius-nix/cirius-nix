{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf getExe getExe';
  deCfg = config.${namespace}.desktop-environment;
in
{
  config = mkIf (deCfg.kind == "hyprland") {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "${getExe config.programs.hyprlock.package}";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "${getExe config.programs.swaylock.package}";
          }
          {
            timeout = 600;
            on-timeout = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms off";
            on-resume = "${getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms on";
          }
        ];
      };
    };

    systemd.user.services.hypridle.Install.WantedBy = [ "hyprland-session.target" ];
  };
}
