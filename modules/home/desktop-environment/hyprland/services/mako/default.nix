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
    ;
  deCfg = config.${namespace}.desktop-environment;
  hyprCfg = deCfg.hyprland;
  cfg = hyprCfg.services.mako;

  enabled = pkgs.stdenv.isLinux && deCfg.kind == "hyprland" && cfg.enable;

  dependencies = with pkgs; [
    mako
    libnotify
  ];
in
{
  options.${namespace}.desktop-environment.hyprland.services.mako = {
    enable = mkEnableOption "mako";
  };

  config = mkIf enabled {
    home.packages = dependencies;
    xdg.configFile."mako/config".source = ./config.ini;
    systemd.user.services.mako = {
      enable = true;
      after = [ "graphical-session.target" ];
      description = "Mako Notification Daemon";
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecCondition = "${pkgs.bash}/bin/bash -c '[ -n \"$WAYLAND_DISPLAY\" ]'";
        ExecStart = "${pkgs.mako}/bin/mako";
        ExecReload = "${pkgs.mako}/bin/makoctl reload";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
