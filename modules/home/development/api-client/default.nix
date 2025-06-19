{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.${namespace}.development.api-client;
in
{
  options.${namespace}.development.api-client = {
    enable = mkEnableOption "API Client";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      postman
      bruno
      bruno-cli
    ];
  };
}
