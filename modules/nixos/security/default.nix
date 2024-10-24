{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.security;
in
{
  options.cirius.security = {
    enable = mkEnableOption "Security";
  };

  config = mkIf cfg.enable {
    security.rtkit = {
      inherit (cfg) enable;
    };
  };
}
