{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.applications.office;
in
{
  options.${namespace}.applications.office = {
    enable = mkEnableOption "office";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice
      # collabora-online
    ];
  };
}
