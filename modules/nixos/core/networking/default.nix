{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.${namespace}.core.network;
in
{
  options.${namespace}.core.network = {
    enable = mkEnableOption "Network";
    hostname = mkOption {
      description = "Hostname";
      type = types.str;
      default = "";
    };
    enableWarp = mkEnableOption "Cloudflare WARP";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ dig ];
    services.cloudflare-warp = {
      enable = cfg.enableWarp;
    };
    networking = {
      dhcpcd = {
        inherit (cfg) enable;
      };
      extraHosts = ''
        # extra hosts
      '';
      hostName = cfg.hostname;
      networkmanager = {
        inherit (cfg) enable;
        wifi = {
          powersave = false;
        };
      };
      firewall = {
        enable = true;
      };
    };
  };
}
