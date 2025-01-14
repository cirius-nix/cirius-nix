{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.packages.stacer;
in
{
  options.${namespace}.packages.stacer = {
    enable = mkEnableOption "stacer";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        stacer
      ];
    };
  };
}
