{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.cirius.virtualisation;
in
{
  options.cirius.virtualisation = {
    enable = mkEnableOption "Virtualisation";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      arion
      dive
      podman
      podman-tui
      podman-compose
    ];
  };
}
