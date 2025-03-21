{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.applications.api;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.${namespace}.applications.api = {
    enable = mkEnableOption "Enable API Applications";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yaak
    ];
  };
}
