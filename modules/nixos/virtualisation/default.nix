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
        dockerSocket.enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      vmware = {
        host = {
          enable = true;
        };
      };
      waydroid = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      arion
      dive
      podman-tui
      podman-compose
      docker-client
    ];

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
