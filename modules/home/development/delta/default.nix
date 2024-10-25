{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.development.delta;
in
{
  options.cirius.development.delta = {
    enable = mkEnableOption "Delta";
  };

  config = mkIf cfg.enable { home.packages = [ pkgs.delta ]; };
}
