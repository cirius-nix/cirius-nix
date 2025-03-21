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
    virtualHosts = mkOption {
      description = "Virtual Hosts";
      type = types.submodule {
        options = {
          enable = mkEnableOption "Enable virtual hosts. (Using nginx)";
          hosts = mkOption {
            type = types.attrsOf types.submodule {
              options = {
                root = mkOption {
                  description = "Root";
                  type = types.str;
                };
              };
            };
            description = "Hostnames";
            default = { };
          };
        };
      };
      default = { };
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dig
      motrix
    ];
    services.cloudflare-warp = {
      enable = cfg.enableWarp;
    };
    services.nginx = mkIf cfg.virtualHosts.enable {
      enable = true;
      virtualHosts = lib.mergeAttrs [ cfg.virtualHosts.hosts ];
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
