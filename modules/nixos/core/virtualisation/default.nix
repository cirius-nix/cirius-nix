{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkOption;

  cfg = config.${namespace}.core.virtualisation;
in
{
  options.${namespace}.core.virtualisation = {
    enable = mkEnableOption "Virtualisation";
    waydroid = mkOption {
      type = lib.types.submodule {
        options = {
          enable = mkEnableOption "Enable Waydroid";
          autoStart = mkEnableOption "Auto start Waydroid";
        };
      };
      default = { };
      description = ''Waydroid is a container-based approach to running Android apps on Linux.'';
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      waydroid = {
        inherit (cfg.waydroid) enable;
      };
      virtualbox.host = {
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

    systemd.user.services = mkIf cfg.waydroid.enable {
      waydroid = {
        enable = cfg.waydroid.autoStart;
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
