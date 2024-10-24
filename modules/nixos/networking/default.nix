{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.network;
in
{
  options.cirius.network = {
    enable = mkEnableOption "Network";
  };

  config = mkIf cfg.enable {
    networking = {
      dhcpcd = {
        inherit (cfg) enable;
      };

      networkmanager = {
        inherit (cfg) enable;

        wifi = {
          backend = "iwd";
          powersave = false;
        };
      };

      firewall = {
        enable = true;
        #   allowedTCPPorts = [ ];
        #   allowedUDPPorts = [ ];
      };
    };
  };
}
