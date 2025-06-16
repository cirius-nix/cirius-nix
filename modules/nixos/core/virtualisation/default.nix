{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.${namespace}.core) virtualisation;
in
{
  options.${namespace}.core.virtualisation = {
    enable = mkEnableOption "Virtualisation";
    virtualbox = {
      enable = mkEnableOption "Enable Virtualbox";
    };
    waydroid = {
      enable = mkEnableOption "Enable Waydroid";
      autoStart = mkEnableOption "Auto start Waydroid";
    };
  };

  config = mkIf virtualisation.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      waydroid = {
        inherit (virtualisation.waydroid) enable;
      };
      virtualbox.host = mkIf virtualisation.virtualbox.enable {
        enable = true;
        enableExtensionPack = true;
      };
    };

    environment.systemPackages = with pkgs; [
      arion
      dive
      podman-tui
      podman-compose
      docker-client
      distrobox
    ];

    systemd.user.services = mkIf virtualisation.waydroid.enable {
      waydroid = {
        enable = virtualisation.waydroid.autoStart;
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
