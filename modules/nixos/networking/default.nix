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

      hostName = "cirius";

      networkmanager = {
        inherit (cfg) enable;
      };

      firewall = {
        enable = true;
        #   allowedTCPPorts = [ ];
        #   allowedUDPPorts = [ ];
      };
    };
  };
}
