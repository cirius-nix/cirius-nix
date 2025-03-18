{
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.${namespace}.applications.benchmark;
in
{
  options.${namespace}.applications.benchmark = {
    enable = mkEnableOption "benchmark";
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      phoronix-test-suite
      st
    ];
  };
}
