{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.virtualisation;
in
{
  options.cirius.virtualisation = {
    enable = mkEnableOption "Virtualisation";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
      };
      waydroid = {
        enable = true;
      };
    };

    systemd.user.services = {
      waydroid = {
        enable = true;
        description = "Waydroid Session Services";
        wantedBy = [ "graphical-session.target" ];
        after = [
          "network-online.target"
          "graphical-session.target"
        ];
        serviceConfig = {
          Type = "simple";
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
          ExecStart = "${pkgs.waydroid}/bin/waydroid session start";
          ExecStop = "${pkgs.waydroid}/bin/waydroid session stop";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };
    };
  };
}
