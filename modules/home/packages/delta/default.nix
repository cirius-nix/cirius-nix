{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.packages.delta;
in
{
  options.cirius.packages.delta = {
    enable = mkEnableOption "Delta";
  };

  config = mkIf cfg.enable { home.packages = [ pkgs.delta ]; };
}
